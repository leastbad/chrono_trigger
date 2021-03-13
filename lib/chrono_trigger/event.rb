# frozen_string_literal: true

module ChronoTrigger
  class Event
    class << self
      def schedule(*args)
        id = SecureRandom.uuid
        options = OpenStruct.new(
          id: id,
          scope: @scope,
          repeats: @repeats || 1,
          every: @every || 1.second,
          at: @at,
          before: @before,
          after: @after
        )
        event = self.new(options, args)
        id
      end

      def scope(value)
        return unless value
        @scope = value if value.is_a?(String)
        @scope = value.to_gid.to_s if value.is_a?(ActiveRecord::Base)
        self
      end

      def repeats(value)
        return unless value
        @repeats = value if value.integer? || value == :forever
        self
      end

      def every(value)
        return unless value
        @every = value if value.is_a?(ActiveSupport::Duration)
        @every = value.seconds if value.integer?
        self
      end

      def at(value)
        return unless value
        @at = value if value.is_a?(ActiveSupport::TimeWithZone)
        @at = Time.zone.parse(value) if value.is_a?(String)
        self
      end

      def before(value)
        return unless value
        @before = value if value.is_a?(ActiveSupport::TimeWithZone)
        @before = Time.zone.parse(value) if value.is_a?(String)
        self
      end

      def after(value)
        return unless value
        @after = value if value.is_a?(ActiveSupport::TimeWithZone)
        @after = Time.zone.parse(value) if value.is_a?(String)
        self
      end
    end

    attr_reader :id, :scope, :args, :every, :before, :after, :purge
    attr_accessor :repeats, :at

    def initialize(options, args)
      @id = options.id
      @scope = options.scope
      @repeats = options.repeats
      @every = options.every
      @at = options.at
      @before = options.before
      @after = options.after
      @args = args
      @purge = false
      ChronoTrigger.schedule.add(self)
    end

    def purge!
      puts "purging #{id}"
      @purge = true
    end

    private

    def perform(args)
      raise NotImplementedError
    end
  end
end