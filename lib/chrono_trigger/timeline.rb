# frozen_string_literal: true

module ChronoTrigger
  module Timeline
    extend ::ActiveSupport::Concern

    def chrono_trigger
      ChronoTrigger::Schedule.instance
    end
  end
end