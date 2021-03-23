# frozen_string_literal: true

module ChronoTrigger
  class Worker < Concurrent::Actor::RestartingContext
    def on_message(event)
      Rails.logger.debug "ChronoTrigger: #{event.inspect}"
      event.perform(*event.args) if event.at.nil? || (event.before && event.at < event.before)
    end
  end
end
