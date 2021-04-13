# The Clock

`ChronoTrigger::Clock` is running the show around here.

Every 100ms \([configurable via initializer](setup.md#optional-create-an-initializer)\) the `Clock` commands the scheduler to process any pending events.

## API

### Methods

#### start

#### stop

### Accessors

#### status

#### stopped?

#### ticks

#### ticking?

### Toggling between starting and stopping

```ruby
ChronoTrigger::Clock.send(ChronoTrigger::Clock.ticking? ? :stop : :start)
```

