# The Clock

`ChronoTrigger::Clock` is running the show around here.

Every 100ms \([configurable via initializer](setup.md#optional-create-an-initializer)\) the `Clock` commands the scheduler to process any pending events.

## API

### Methods

#### start

Start \(or un-pause\) the `Clock`. Note that events with a `before` attribute that has already passed will be purged without being run.

#### stop

Pause the `Clock`.

### Accessors

#### status

This will return `:started` or `:stopped`.

#### stopped?

This will return `true` or `false`, depending on whether the `Clock` is currently paused or not.

#### ticks

This will return an Integer representing the number of [ticks](time.md#ticks) which have happened since the `Clock` was started.

#### ticking?

The counterpart to `stopped?`, this will return `true` or `false` depending on whether the `Clock` is currently paused or not.

## Toggling between starting and stopping

Here's a trick to flip the current `status`:

```ruby
ChronoTrigger::Clock.send(ChronoTrigger::Clock.ticking? ? :stop : :start)
```

