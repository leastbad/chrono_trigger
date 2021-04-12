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
        new(options, args)
      end

      def scope(value)
        return self unless value
        @scope = value if value.is_a?(String)
        @scope = value.to_gid.to_s if value.is_a?(ActiveRecord::Base)
        self
      end

      def repeats(value)
        return self unless value
        @repeats = value.count if value.is_a?(Enumerator)
        @repeats = value if value.is_a?(Integer) || value == :forever
        self
      end

      def every(value)
        return self unless value
        @every = value if value.is_a?(ActiveSupport::Duration)
        @every = value.seconds if value.is_a?(Integer)
        self
      end

      def at(value)
        return self unless value
        value = Time.zone.parse(value) if value.is_a?(String)
        @at = moment_in_the_future(value) if value.is_a?(ActiveSupport::TimeWithZone)
        self
      end

      def before(value)
        return self unless value
        value = Time.zone.parse(value) if value.is_a?(String)
        @before = moment_in_the_future(value) if value.is_a?(ActiveSupport::TimeWithZone)
        self
      end

      def after(value)
        return self unless value
        value = Time.zone.parse(value) if value.is_a?(String)
        @after = moment_in_the_future(value) if value.is_a?(ActiveSupport::TimeWithZone)
        self
      end

      private

      include ChronoTrigger::Helpers::MITF
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

    def ticks
      ChronoTrigger::Clock.ticks
    end

    def purge!
      @purge = true
    end

    include ChronoTrigger::Helpers::MITF
    include ChronoTrigger::Helpers::Now

    def to_s
      inspect
    end

    private

    def perform(args)
      raise NotImplementedError
    end
  end
end
