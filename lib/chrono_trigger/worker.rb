# frozen_string_literal: true

module ChronoTrigger
  class Worker < Concurrent::Actor::RestartingContext
    def on_message(event)
      event.perform(*event.args)
    end
  end
end
