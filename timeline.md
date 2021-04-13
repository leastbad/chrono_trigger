# Timeline

## Concern

`ChronoTrigger::Timeline` is a Concern that can be included in your Controllers, Models Jobs, Reflexes, Channels, Mailers, Helpers, rake tasks and anywhere else you want to schedule an `Event`.

```ruby
include ChronoTrigger::Timeline
```

 It provides:

1. The `chrono_trigger` accessor, which gives you the ability to interact with the `Schedule` of upcoming `Event` instances.
2. The `moment_in_the_future(ActiveSupport::TimeWithZone)` and `right_now` [helper methods](events.md#helper-methods).

## Methods

Once you have a reference to the `chrono_trigger` accessor, you gain new powers over your `Event` instances.

**add\(**ChronoTrigger::Event**\)**: While usually called for you when scheduling an `Event` instance, it is also possible to pass a valid `Event` directly to `add` 

**clear**: Empty the `Schedule` completely and without regard for `scope`. Use with due caution! 😰

**clear\_scope\(**String or ActiveRecord::Base**\)**: Remove all `Event` instances from the `Schedule`dd

