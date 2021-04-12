# Setup

ChronoTrigger is designed to work with Rails 5.2 and beyond. It has minimal gem dependencies and no infrastructure dependencies.

```bash
bundle add chrono_trigger
mkdir app/events
```

In the `app/events` folder, we will create an `ApplicationEvent` class for our `Event` classes to inherit from:

{% code title="app/events/application\_event.rb" %}
```ruby
class ApplicationEvent < ChronoTrigger::Event
  include CableReady::Broadcaster
  # delegate :render, to: ApplicationController
end
```
{% endcode %}

While you can use ChronoTrigger to run any code, it has been designed to work with [CableReady](https://cableready.stimulusreflex.com). Including `CableReady::Broadcaster` makes the `cable_ready` method available to all of your `Event` classes.

If you plan to use CableReady to send rendered HTML, you might wish to delegate `render` to `ApplicationController`.

Finally, you need to start the `Clock`! The best place to do this is after Puma starts up:

{% code title="config/puma.rb" %}
```ruby
# place this at the bottom of puma.rb
ChronoTrigger::Clock.start
```
{% endcode %}

#### Optional: Create an initializer

Today, it's possible to configure the resolution of the timer, but the 100ms default is likely fine. There will be additional options added in the future:

{% code title="config/initializers/chrono\_trigger.rb" %}
```ruby
ChronoTrigger.configure do |config|
  config.interval = 0.1 # 100ms
end
```
{% endcode %}

{% hint style="info" %}
You might be wondering: why not start the `Clock` in the initializer? The reason is that you only want to run ChronoTrigger in the web server process - not Sidekiq, console, when running migrations and other rake tasks...
{% endhint %}

