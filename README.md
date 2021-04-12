---
description: Make Rails apps that feel alive.
---

# ChronoTrigger

[![GitHub stars](https://img.shields.io/github/stars/leastbad/chrono_trigger?style=social)](https://github.com/leastbad/chrono_trigger) [![GitHub forks](https://img.shields.io/github/forks/leastbad/chrono_trigger?style=social)](https://github.com/leastbad/chrono_trigger) [![Twitter follow](https://img.shields.io/twitter/follow/theleastbad?style=social)](https://twitter.com/theleastbad) [![Discord](https://img.shields.io/discord/681373845323513862)](https://discord.gg/GnweR3)

ChronoTrigger is a clock-based scheduler that runs inside your Rails app. Use it to run code \(events\) at specific times and intervals.

![](.gitbook/assets/chrono-trigger.jpg)

## Why use ChronoTrigger?

Nobody wants to be the first person to arrive at a club, and yet, this is exactly what most app onboarding processes feel like.

A typical visitor will spend _7-12 seconds_ evaluating your hard work before deciding if they will engage. You must convey that _exciting things are happening_, or they will close the tab and forget you exist.

**ChronoTrigger is a tool designed to breathe life into otherwise static user interfaces and onboarding experiences.**

It allows you to subtly expose users to a crafted narrative that nudges them forward, without feeling like a canned theme park ride. The story is advanced by their actions and their engagement is rewarded with simulated interaction, even if they are user number one.

## Is ChronoTrigger for you?

If you spend months building something cool, and then hustle to get people to check it out, you get exactly one chance to make your first and only impression. It's up to you to do everything you can to make sure that your app is special enough to love. To succeed long-term, you need these first users to become cheerleaders and evangelize to their friends.

If you think about the stand-out [onboarding success stories](https://www.useronboard.com/user-onboarding-teardowns/) like Slack, they all prioritize anticipating what the user will be thinking, feeling and wondering during each _moment_ of the first minutes the user spends on the site.

ChronoTrigger is for developers who are proud of what they have created; tech founders looking for a way to give new users an aspirational story to tell themselves. This converging path leads to feelings of ownership and drives conversion without a hard sell.

You will use ChronoTrigger to orchestrate the onboarding experience your app deserves:

* interactive demos, charts and UI elements
* automation / wizards that feel personal
* placeholder content that changes to help tell a story
* a path through features instead of just clicking everything
* simulated human responses and exchanges

### Why not ActiveJob?

ActiveJob is amazing, but creating Jobs for typical ChronoTrigger use cases feels like taking a taxi to the next house.

Jobs are not designed to run immediately, and priority should be given to important things like mail delivery. There's also functionality in the Event class that would be hard to retrofit to Job classes.

It's also worth mentioning that requiring Sidekiq would require Heroku users to set up a worker dyno, even if you're not using ActiveJob. Finally, Sidekiq sometimes runs jobs multiple times!

## How does ChronoTrigger work?

ChronoTrigger runs on real world time, like trains. Every second, on the second, ChronoTrigger decides whether there are new events to run. If so, there's a thread-safe and highly-optimized pool of workers waiting.

{% hint style="info" %}
Other event scheduling libraries tend to be either `cron` wrappers or use timing offsets \(think: `sleep 1`\) from whenever they are called and don't factor in their own timing footprint. In other words, 1000 loops later, more than 1000 seconds have passed. No good!
{% endhint %}

You start the ChronoTrigger Clock after your web server, and it runs inside your Rails app process.

ChronoTrigger Events live in `app/events` and follow a structure that will be familiar to ActiveJob users.

You can schedule Events from anywhere in your application that it makes sense to do so, such as:

* Controller actions and webhook callbacks
* ActiveRecord model callbacks
* Devise session/registration callbacks
* Reflex action methods
* ActionCable Connection/Channel subscription callbacks

## Design concepts and goals

* Not a replacement for ActiveJob \(or cron!\)
* Events are ephemeral and disposable; failure should be fine 🤷
* Borrow the best ideas from the ActiveJob and CableReady APIs
* ActiveSupport::TimeWithZone all the way down
* All times are today, rounded to 1s for easy comparison
* Times are memoized to avoid side effects
* Events should be short term and soon; _there is no tomorrow_
* Run in-process with no additional infrastructure dependencies

## Key features and advantages

* A natural fit with [CableReady](https://cableready.stimulusreflex.com/)
* Easy to learn, quick to implement
* Plays well with tools such as [StimulusReflex](https://docs.stimulusreflex.com/) and [Turbo Drive](https://turbo.hotwire.dev/handbook/drive)
* Configurable via an optional initializer file
* Worker pool provided by the excellent [concurrent-ruby](https://github.com/ruby-concurrency/concurrent-ruby) library

## Try it now

![](.gitbook/assets/soon.jpg)

