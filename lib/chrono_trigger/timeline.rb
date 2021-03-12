# frozen_string_literal: true

require_relative "clock"

module ChronoTrigger
  module Timeline
    extend ::ActiveSupport::Concern

    def chrono_trigger
      ChronoTrigger::Clock.instance
    end
  end
end