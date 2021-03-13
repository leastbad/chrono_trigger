# frozen_string_literal: true

module ChronoTrigger
  class Event
    attr_reader :id, :args, :repeats, :every, :at, :before, :after

    class << self

      def schedule(*args)
        id = SecureRandom.uuid
        options = OpenStruct.new(
          id: id,
          repeats: @repeats || 1,
          every: @every || 1.second,
          at: @at || "",
          before: @before || "",
          after: @after || ""
        )
        event = self.new(options, args)
        id
      end

      def at(value)
        @at = value if value&.is_a?(String) || value&.is_a?(ActiveSupport::TimeWithZone)
      end

      def before(value)
        @before = value if value&.is_a?(String) || value&.is_a?(ActiveSupport::TimeWithZone)
      end

      def after(value)
        @after = value if value&.is_a?(String) || value&.is_a?(ActiveSupport::TimeWithZone)
      end

      private

      def repeats(value)
        @repeats = value if value&.integer? || value == :forever
      end

      def every(value)
        @every = value if value&.is_a?(ActiveSupport::Duration) || value&.integer?
      end

    end

    def initialize(options, args)
      @id = options.id
      @repeats = options.repeats
      @every = options.every
      @at = Time.zone.parse(options.at)
      @before = Time.zone.parse(options.before)
      @after = Time.zone.parse(options.after)
      @args = args
      ChronoTrigger.schedule.add(self)
    end

    private

    def perform(args)
      raise NotImplementedError
    end
  end
end