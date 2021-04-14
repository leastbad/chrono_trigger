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

**add\(**ChronoTrigger::Event**\)**: While usually called for you when scheduling an `Event` instance, it is also possible to pass a valid `Event` directly to `add`.

**clear**: Purge the `Schedule` completely and without regard for `scope`. This means that all users will not see their `Event`. Use with due caution! 😰

**clear\_scope\(**String or ActiveRecord::Base**\)**: Purge all `Event` instances from the `Schedule` that are an exact match for the `scope` passed to it. Usually, this means either all events for a specific user or resource, or all events for a topic or tag not represented by a resource.

**events**: This will return a thread-safe Array which contains all of the `Event` instances currently present in the system.

**remove\(**String or ChronoTrigger::Event**\)**: Remember back when I suggested that you store references to your created `Event` instances? The `remove` method accepts either the `id` of an `Event` \(which will be a UUIDv4\) or the `Event` object itself. If the signature matches, the `Event` will be marked for purging at the next tick.

