---
description: Make Rails apps that feel alive.
---

# ChronoTrigger

The `chrono_trigger` gem is a clock-based event scheduler that runs inside your Rails app. It runs code at specific times and intervals.

[![GitHub stars](https://img.shields.io/github/stars/leastbad/chrono_trigger?style=social)](https://github.com/leastbad/chrono_trigger) [![GitHub forks](https://img.shields.io/github/forks/leastbad/chrono_trigger?style=social)](https://github.com/leastbad/chrono_trigger) [![Twitter follow](https://img.shields.io/twitter/follow/theleastbad?style=social)](https://twitter.com/theleastbad) [![Discord](https://img.shields.io/discord/681373845323513862)](https://discord.gg/GnweR3)

## Why use ChronoTrigger?

Nobody wants to be the first person to arrive at a club, and yet, this is _exactly_ what most app onboarding processes feel like:

![](.gitbook/assets/5479.webp)

After you spend months building something cool, you have to hustle just to get people to check it out. A typical visitor will spend _7-12 seconds_ evaluating your hard work before deciding if they will engage. You get one chance to [recruit your first followers](https://www.youtube.com/watch?v=V74AxCqOTvg)... or else, they will close the tab and forget you exist.

[Onboarding success stories](https://www.useronboard.com/user-onboarding-teardowns/) like Slack prioritize anticipating what the user will be thinking, feeling and wondering during each _moment_ of their first minutes on the site.

**ChronoTrigger is a tool designed to breathe life into otherwise static user interfaces and onboarding experiences.**

## Is ChronoTrigger for you?

ChronoTrigger is for developers looking to orchestrate the onboarding experience your app deserves, **without the hard sell**:

* interactive demos, charts and UI elements
* automation and wizards that feel personal
* placeholder content that changes to help tell a story
* a path through features instead of just clicking everything
* simulated human responses and exchanges

## Key features and advantages

* A natural fit with [CableReady](https://cableready.stimulusreflex.com/) and [Stimulus](https://stimulus.hotwire.dev/)
* Easy to learn, quick to implement
* Plays well with tools such as [StimulusReflex](https://docs.stimulusreflex.com/) and [Turbo Drive](https://turbo.hotwire.dev/handbook/drive)
* Configurable via an optional initializer file
* Worker pool provided by the excellent [concurrent-ruby](https://github.com/ruby-concurrency/concurrent-ruby) library

## How does ChronoTrigger work?

ChronoTrigger runs on real world time, just like trains. 🚂

Every second, on the second, ChronoTrigger's thread-safe worker pool checks to see if there are new events to run.

{% hint style="info" %}
Other event scheduling libraries tend to be either `cron` wrappers or use timing offsets \(think: `sleep 1`\) from whenever they are called and don't factor in their own timing footprint. In other words, 1000 loops later, more than 1000 seconds have passed. No good! 🙅‍♂️
{% endhint %}

You start the ChronoTrigger Clock after your web server, and it runs inside your Rails app process.

ChronoTrigger Events live in `app/events` and follow a structure that will be familiar to ActiveJob users.

You can schedule Events from anywhere in your application that it makes sense to do so, such as:

* Controller actions and webhook callbacks
* ActiveRecord model callbacks
* Devise session/registration callbacks
* Reflex action methods
* ActionCable Connection/Channel subscription callbacks

## Try it now

Github repo and Heroku demo coming soon.

