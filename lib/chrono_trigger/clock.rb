# frozen_string_literal: true

module ChronoTrigger
  class Clock
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
                ChronoTrigger.schedule.process_events
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
  end
end