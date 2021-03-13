# frozen_string_literal: true

require "singleton"

module ChronoTrigger
  class Schedule
    include Singleton

    attr_reader :events

    def initialize
      @events = []
    end

    def add(event)
      @events << event if event&.is_a?(ChronoTrigger::Event)
    end

    def remove(uuid)
      uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
      @events.delete_if { |e| e.id == uuid } if uuid && uuid_regex.match?(uuid.to_s.downcase)
    end

    def process_events
      events.each do |event|
        Thread.new do
          event.perform(event.args)
        end
      end
    end
  end
end