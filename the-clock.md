# The Clock

## API

### Methods

#### start

#### stop

### Accessors

#### status

#### stopped?

#### ticks

#### ticking?

## Examples

### Toggling between starting and stopping

```ruby
ChronoTrigger::Clock.send(ChronoTrigger::Clock.ticking? ? :stop : :start)
```

