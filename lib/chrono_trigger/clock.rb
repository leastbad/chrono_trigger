# frozen_string_literal: true

module ChronoTrigger
  class Clock
    class << self
      attr_reader :status, :ticks

      def init
        @ticks = 0
        @status ||= :stopped
      end

      def start
        init
        if stopped?
          last_tick = Time.zone.now
          Rails.logger.info "ChronoTrigger: Clock started with a #{ChronoTrigger.config.interval}s interval"
          ChronoTrigger.schedule.refresh
          task = Concurrent::TimerTask.new(execution_interval: ChronoTrigger.config.interval) do |task|
            if Time.zone.now - last_tick >= 1
              last_tick += 1
              @ticks += 1
              ChronoTrigger.schedule.process_events
            end
            task.shutdown if stopped?
          end
          task.execute
        end

        @status = :started
      end

      def stop
        if ticking?
          Rails.logger.info "ChronoTrigger: Timer stopped"
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
