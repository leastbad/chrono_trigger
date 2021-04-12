# frozen_string_literal: true

module ChronoTrigger
  module Helpers
    module Now
      def right_now
        now = Time.zone.now
        Time.zone.today + now.hour.hours + now.min.minutes + now.sec.seconds
      end
    end
  end
end