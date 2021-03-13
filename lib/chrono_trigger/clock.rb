# frozen_string_literal: true

require "singleton"

module ChronoTrigger
  class Clock
    include Singleton
    attr_reader :events

    class << self

      attr_reader :status

      def init
        @status = :stopped unless @status
      end

      def start
        init
        if stopped?
          Thread.new do
            last_tick = Time.now
            loop do
              sleep ChronoTrigger.config.interval
              if Time.now - last_tick >= 1
                last_tick += 1
                Thread.new do
                  ExampleEvent.schedule
                end
              end
              break if stopped?
            end
          end
        end

        @status = :started
      end

      def stop
        if ticking?
          @status = :stopped
        end
        @status
      end

      def ticking?
        @status == :started
      end

      def stopped?
        @status == :stopped
      end
    end

    def initialize
      @events = []
    end

    def add_event(event)
      @events << event
    end

    def remove_event(uuid)
      @events.reject! { |k,v| v == uuid }
    end
  end
end