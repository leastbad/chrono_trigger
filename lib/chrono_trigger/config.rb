# frozen_string_literal: true

require "monitor"
require "observer"
require "singleton"

module ChronoTrigger
  class Config
    include MonitorMixin
    include Observable
    include Singleton

    attr_accessor :interval
    attr_reader :events

    def initialize
      super
      @interval = 0.1
      @events = []
    end

    def observers
      @observer_peers&.keys || []
    end

    def add_event(name)
      synchronize do
        @event_names << name.to_sym
        notify_observers name.to_sym
      end
    end
  end
end
