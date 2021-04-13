# Time

## A Brief History

ChronoTrigger was originally conceived as a solution to what I saw as a strange blind-spot in Ruby: you can't easily make an accurate world clock that will count seconds at the exact same time as, for example, an atomic clock.

It seems like this should be trivially easy, and in some languages it is. Ruby can `sleep`, but this is really just an offset from whatever arbitrary moment you call it eg. statistically never on the second.

Worse, if your instructions take longer than a second to process, then I guess you just sleep from that moment - leading to a reality where every Ruby minute has "60, or fewer" seconds. That's some bullshit!

I was embarrassed that Ruby couldn't just reliably syncronize with the NYE ball drop or a NASA countdown.

That makes ChronoTrigger a bit of an eccentricity, as libraries go. Ruby doesn't give us a way to execute code on the second, but ChronoTrigger gets close enough to fake it, convincingly, in a non-blocking and resource-efficient way.

![Chrono Trigger \(1995\)](.gitbook/assets/dvs0n3lxkaaa__k.jpg)

## ChronoTrigger Time

There are some [simple laws](https://tardis.fandom.com/wiki/Laws_of_Time) which govern how time works when using ChronoTrigger:

* "Yesterday" and "tomorrow" are lies; **every day is today**. When `23:59:11` flips over, it is now `00:00:00`, _today_
* All times are represented as `ActiveSupport::TimeWithZone` 
* There is no unit of time shorter than one second, and all times have their precision rounded down to the second

These requirements make it easy to both compare times and do time calculations like `right_now + 1.minute` or `moment_in_the_future(16.seconds.from_now)`.

ChronoTrigger events are designed to be _low-stakes_ and they are supposed to happen **soon**. Otherwise, ActiveJob or `cron` are likely better suited to your problem.

## Ticks 🐞🐞🐞

Ticks are how ChronoTrigger refers to the beginning of the next clock second. It's always less than a second away. Don't blink! 😲

From the moment your server boots and the `Clock` starts, every second is a new tick. You can actually see how many ticks have passed since the server was started by running the `ticks` helper method inside your event's `perform` method, or directly inspecting the `Clock` itself:

```ruby
puts ChronoTrigger::Clock.ticks
```

You might find creative uses for ticks, especially if you sometimes [pause](the-clock.md#stop) the `Clock`.

In such a scenario, you might find yourself wondering how many ticks have occurred, _even if far more IRL time has passed_.

