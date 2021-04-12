# Events

## Create and schedule an event

First, let's create the simplest `Event` possible:

{% code title="app/events/example\_event.rb" %}
```ruby
class ExampleEvent < ApplicationEvent
  def perform
    puts "Hello from ChronoTrigger."
  end
end
```
{% endcode %}

We can now _schedule_ an instance of the `Event` using the `schedule` method of the `ExampleEvent` class:

```ruby
event = ExampleEvent.schedule
```

{% hint style="success" %}
It's a good idea to assign `Event` instances to a variable so that you can access important attributes and methods you'll use later.
{% endhint %}

With no parameters or options specified, this `ExampleEvent` will run one time. This will happen at the next **tick**.

## Ticks

Ticks are how ChronoTrigger refers to the beginning of the next clock second. It's always less than a second away. Don't blink! 😲

From the moment your server boots and the `Clock` starts, every second is a new tick. You can actually see how many ticks have passed since the server was started by running the `ticks` helper method inside your event's `perform` method, or directly inspecting the `Clock` itself:

```ruby
puts ChronoTrigger::Clock.ticks
```

You might find creative uses for ticks, especially if in your application you sometimes [pause](the-clock.md#stop) the `Clock`. In such a scenario, you might find yourself wondering how many ticks have occurred, even if far more IRL time has passed.

## Event attributes

`Event` instances have a number of attributes that you can use to control how, when and even if they occur:

**id**: a UUIDv4 that uniquely identifies the `Event` instance.

**scope**: an optional value that can either be a String or an ActiveRecord model instance \(a resource like `User.first` or `current_user`\). Used for tracking who or what created the `Event` instance.

**repeats**: how many times will this `Event` instance be performed? Defaults to 1. It can be set to an Integer, an Enumerator \(such as `5.times`\) or the Symbol `:forever` which does exactly what you think it does, so use it with caution.

**every**: how many ticks between each repetition? Defaults to every second. It can be set to an Integer or a Duration such as `3.seconds`.

**at**: what time will the `Event` instance next be called? Defaults to the next tick. It can be set to a String that will be parsed into a `ActiveSupport::TimeWithZone` or you can pass an `ActiveSupport::TimeWithZone` directly.

**before**: only run this `Event` instance until a certain time in the future. It can be set to a String that will be parsed into a `ActiveSupport::TimeWithZone` or you can pass an `ActiveSupport::TimeWithZone` directly.

**after**: only run this `Event` instance after a certain time. It can be set to a String that will be parsed into a `ActiveSupport::TimeWithZone` or you can pass an `ActiveSupport::TimeWithZone` directly.

## Method chaining

You can provide values for some or all of an `Event` instance's attributes using chained methods:

```ruby
ExampleEvent.scope(current_user).repeats(:forever).after(Time.zone.now + 21.seconds).before(Time.zone.now + 1.minute).schedule
```

In this scenario, starting in 21 ticks, an instance of `ExampleEvent` will be performed every second. Even though the instance is set to repeat forever, it will ultimately stop 60 ticks after it started.

Also, the instance is **scoped** to the current user. While optional, this is a very handy way to keep track of which events belong to which user or resource. If a user disconnects or a `Post` is destroyed, you can purge all of the events for that resource.

```ruby
ExampleEvent.at(5.minutes.from_now).schedule
```

Great pains have been taken to make sure that ChronoTrigger instructions parse as English-like, in the hope that it allows less-technical individuals to follow the logic.

## Class methods

If you know that you want every instance of an `Event` to share the same attributes, there's no easier way that to specify those attributes with class methods:

{% code title="app/events/example\_event.rb" %}
```ruby
class ExampleEvent < ApplicationEvent
  repeats 5.times
  every 3.seconds
  
  def perform
    puts "Hello from ChronoTrigger."
  end
end
```
{% endcode %}

Starting on the next tick, each instance of `ExampleEvent` will repeat every 3 seconds for a total of 5 times over 15 seconds.

{% hint style="success" %}
You can combine attributes set with class methods and chained methods. Note that attributes set via chained methods take precedence over class methods, allowing you to set meaningful defaults in your `Event` class and then override them like a pirate when actually scheduling.
{% endhint %}

## Helper methods

**moment\_in\_the\_future\(**ActiveSupport::TimeWithZone**\)**: accepts a \`ActiveSupport::TimeWithZone\` that **must be in the future**. Returns an `ActiveSupport::TimeWithZone` that is **today** and has no fractional seconds.

**purge!**: ****Marks the instance for death at the beginning of the next tick. _As with other dead things_, it will not run again. Note: you can inspect the `purge` accessor boolean inside of your `Event` class.

**right\_now**: Returns the current time with no fractional seconds.

**ticks**: Returns the number of ticks which have occurred since the `Clock` was started. 🐞

