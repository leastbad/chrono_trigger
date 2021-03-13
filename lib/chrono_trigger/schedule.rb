# frozen_string_literal: true

module ChronoTrigger
  class Schedule
    include Singleton
    attr_reader :events

    def initialize
      @events = []
    end

    def add(event)
      @events << event if event&.is_a?(ChronoTrigger::Event)
      self
    end

    def remove(uuid)
      uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
      @events.each { |event| event.purge! if event.id == uuid } if uuid && uuid_regex.match?(uuid.to_s.downcase)
      self
    end

    def clear
      @events.each { |event| event.purge! }
      self
    end

    def clear_scope(value)
      return self unless value
      scope = value if value.is_a?(String)
      scope = value.to_gid.to_s if value.is_a?(ActiveRecord::Base)
      @events.each { |event| event.purge! if event.scope == scope }
      self
    end

    def process_events
      events.each do |event|
        if event.purge || (event.before && Time.zone.now > event.before) || event.repeats == 0
          @events.delete(event)
          next
        end
        Thread.new do
          event.perform(event.args)
        end
        event.repeats -= 1 unless event.repeats == :forever
      end
    end
  end
end