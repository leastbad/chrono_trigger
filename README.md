# ChronoTrigger

**This is very much in beta. It's intentionally not released on rubygems.**

ChronoTrigger is an in-process clock for Rails. You use it to run code at specific times and/or at specific intervals. It runs on real world time - like cron - every tick happens not after a `sleep 1` but at the beginning of each chronological second.

Anywhere in your app, you can schedule an event. There's also a singleton method called `chrono_trigger` that lets you add or remove things to run... once, n times or every second until you tell it to stop!

My first use case for this gem is to combine it with CableReady to deliver a string of updates to the client which starts immediately after a user logs in or navigates to a page. Instead of a static UI, I want the user to feel like they are jumping into a site that has shit happening: charts moving, notifications arriving, people liking things on the activity stream... ~~even if it's just a demo~~ because it's a demo and I want it to feel real.

## Potential use cases

- interactive demos and landing pages
- automation / wizards
- onboarding / welcome content
- testing realistic behaviour
- simulated human responses

### Ideal launch scenarios

- Nothing reflexes
- Controller actions
- Devise session/registration success

## Design concepts and goals

- Not a replacement for ActiveJob (or cron!)
- Events are ephemeral and disposable; complete failure should be a non-issue
- Borrow the best ideas from the ActiveMailer, ActiveJob and cable_ready APIs
- ActiveSupport::TimeWithZone all the way down
- All time are today, with accuracy rounded to 1s to enable comparison
- Times used multiple times are memoized to avoid side effects
- Events should be short term and soon; it's impossible to schedule >1 day out
- Run in-process with no external dependencies

Note that while I did initially consider using ActiveJob, I quickly realized that there were many downsides:

- external dependency and moving parts
- felt like taking a taxi to the next house
- jobs can be slow or competing with important things
- hard to add Event-specific class methods and business logic
- jobs might run more than once
- technically Sidekiq needs its own Heroku dyno (I think!?)

## Areas I'd appreciate feedback and review

- Is my use of `Thread` defensible? Is there a better/more suitable primative like fibers or ractors?
- What happens in a multi-dyno situation?
- What happens when there could be thousands of concurrent users? How expensive are threads in the context I use them?
- Should I be using thread local singletons? I'm a bit fuzzy on all of that stuff.

## Module map

### clock.rb

ChronoTrigger::Clock is the timer loop that is running the show. Every 100ms (configurable) it checks to see if it's the next second, and if so, initiates a schedule processing operation. The timer can be stopped and started, as well as interrogated for status. Clock keeps track of how many "ticks" it has processed, and this value is accessible to Event classes.

### timeline.rb

ChronoTrigger::Timeline is a concern that plays the same role as CableReady::Broadcaster in that it provides an accessor to the Schedule singleton, as well as a few helper methods for calculating time parameters:

- `right_now`
- `moment_in_the_future(ActiveSupport::TimeWithZone)`

### schedule.rb

Most of the business logic is here. Everything is built around an `@events` array that contains Event class instances. The `chrono_trigger` accessor gives developers access to the `remove`, `clear` and `clear_scope` methods. In an attempt at thread safety, all three methods mark Event instances with a `purge: true` attribute so that the instances can delete themselves during the next tick.

Event instances can optionally be assigned a "scope" - either a String or an ActiveRecord model - that allows the developer to potentially purge all scheduled events for a resource or pattern. For example, if a user logs out or leaves a page with scripted effects, you don't need the events to fire.

### event.rb

This is the base class that is designed to be subclassed in the user's application:

`ExampleEvent < ApplicationEvent < ChronoTrigger::Event`

Developers create Event classes that have a mandatory `perform` method, similar to ActiveJob. There are several class methods that can be set but all properties of the instance can be specified at the time it is created. The process of scheduling (creating an Event instance that lives in the Schedule#events array) is performed using a syntax that is similar to ActiveMailer and chained CableReady operations.

### config.rb

There is an optional initializer, but right now it just has the `sleep` interval. I am very likely to add the ability to schedule tasks intended to be running forever to the config. Even though you can schedule an event from anywhere, it makes sense to tell people "this is where you should launch your long-running events" so people don't need to think about it.

## Installation and Setup

1. Clone the repo from git@github.com:leastbad/chrono_trigger.git
2. Add the gem to your Gemfile **using `path`**: `gem "chrono_trigger", path: "~/chrono_trigger"`
3. Create your initializer: `config/initializers/chrono_trigger.rb`:
```rb
ChronoTrigger.configure do |config|
  config.interval = 0.1 # also the default
end
```
4. Launch ChronoTrigger from your `config/puma.rb`:
```rb
# bottom of file
require "chrono_trigger/clock"
ChronoTrigger::Clock.start
```
5. Create your `app/events` folder, then create `application_event.rb` and `example_event.rb`:
```rb
require 'chrono_trigger/event'

class ApplicationEvent < ChronoTrigger::Event
  include CableReady::Broadcaster #suggested
  delegate :render, to: ApplicationController #suggested
end
```
```rb
class ExampleEvent < ApplicationEvent
  repeats :forever
  every 3.seconds

  def perform(user, message)
    puts ticks, self.inspect
    cable_ready[UsersChannel].console_log(message: message).broadcast_to(user)
  end
end
```
6. Create a Reflex (and a view) to schedule some events:
```rb
class ExampleReflex < ApplicationReflex
  include ChronoTrigger::Timeline

  def clock
    ChronoTrigger::Clock.send(ChronoTrigger::Clock.ticking? ? :stop : :start)
  end

  def heartbeat
    ExampleEvent.scope(current_user).after(Time.zone.now + 5.seconds).before(Time.zone.now + 21.seconds).schedule(current_user, "hello")
    morph :nothing
  end

  def clear
    chrono_trigger.clear_scope(current_user)
    morph :nothing
  end
end
```
```erb
<div class="col-8 col-lg-6 col-xl-4 mb-4">
  <div class="card border-light shadow-sm components-section">
    <div class="card-header">
      <h3>Clock</h3>
    </div>
    <div class="card-body d-flex justify-content-center">
      <button class="btn btn-dark" type="button" data-reflex="click->Example#clock"><span class="fas fa-clock me-2"></span><%= ChronoTrigger::Clock.ticking? ? "Stop" : "Start" %></button>
    </div>
  </div>
</div>
<div class="col-8 col-lg-6 col-xl-4 mb-4">
  <div class="card border-light shadow-sm components-section">
    <div class="card-header">
      <h3>Heartbeat</h3>
    </div>
    <div class="card-body d-flex justify-content-center">
      <button class="btn btn-dark" type="button" data-reflex="click->Example#heartbeat"><span class="fas fa-heartbeat me-2"></span>Let's gooo</button>
    </div>
  </div>
</div>
<div class="col-8 col-lg-6 col-xl-4 mb-4">
  <div class="card border-light shadow-sm components-section">
    <div class="card-header">
      <h3>Clear Heartbeat</h3>
    </div>
    <div class="card-body d-flex justify-content-center">
      <button class="btn btn-dark" type="button" data-reflex="click->Example#clear"><span class="fas fa-heart-broken me-2"></span>Dear John</button>
    </div>
  </div>
</div>
```
7. Set up a `UsersChannel`:
```rb
class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end
end
```
```js
import consumer from './consumer'
import CableReady from 'cable_ready'

consumer.subscriptions.create('UsersChannel', {
  received (data) {
    if (data.cableReady) CableReady.perform(data.operations)
  }
})
```

## Event schedule API

```rb
ExampleEvent.schedule # is a viable basic case.

ExampleEvent.scope(current_user).repeats(:forever).every(3.seconds).after(5.seconds).before(1.minute).schedule(current_user, 5, true)

ExampleEvent.at(5.minutes.from_now).schedule("index")
```

- id: a UUIDv4 (read-only)
- scope: defaults to nil; accepts a String or an AR model instance
- repeats: defaults to 1, accepts an Integer, an Enumerator (eg. `5.times`) or the symbol `:forever`
- every: defaults to 1.second, accepts an Integer (converted to seconds) or an `ActiveSupport::Duration` eg. `5.seconds`
- at: run at a specific time; defaults to `nil`, accepts `TimeWithZone` or a String that will be parsed to `TimeWithZone`
- before: run an event up until this `TimeWithZone`, defaults to `nil`, String will also be parsed to `TimeWithZone`
- after: run an event starting from this `TimeWithZone` or parsed String, also defaults to `nil`

There are several helper methods available:

- `ticks`
- `purge!`
- `right_now`
- `moment_in_the_future(ActiveSupport::TimeWithZone)`

## Thanks!

I really appreciate you looking at this. I think this could make Rails app onboarding and demos many times more exciting. It's a bonus that it plays so nicely with CableReady.