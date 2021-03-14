# frozen_string_literal: true

module ChronoTrigger
  module Timeline
    extend ::ActiveSupport::Concern

    class LostInTimeError < StandardError
    end

    class TodayIsTomorrowsYesterday < StandardError
    end

    def chrono_trigger
      ChronoTrigger::Schedule.instance
    end

    def right_now
      now = Time.zone.now
      Time.zone.today + now.hour.hours + now.min.minutes + now.sec.seconds
    end

    def moment_in_the_future(time_with_zone)
      raise(LostInTimeError, "Argument must be of type ActiveSupport::TimeWithZone eg. right_now + 1.second") unless time_with_zone.is_a?(ActiveSupport::TimeWithZone)
      raise(TodayIsTomorrowsYesterday, "Time must be in the future eg. 1.second.from_now") unless time_with_zone.future?
      Time.zone.today + time_with_zone.hour.hours + time_with_zone.min.minutes + time_with_zone.sec.seconds
    end
  end
end