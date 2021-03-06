# frozen_string_literal: true

require "rails/engine"
require "active_support/all"
require "singleton"
require "concurrent-edge"
require "chrono_trigger/helpers/mitf"
require "chrono_trigger/helpers/now"
require "chrono_trigger/clock"
require "chrono_trigger/config"
require "chrono_trigger/event"
require "chrono_trigger/schedule"
require "chrono_trigger/timeline"
require "chrono_trigger/version"
require "chrono_trigger/worker"

module ChronoTrigger
  class Engine < Rails::Engine
  end

  def self.config
    ChronoTrigger::Config.instance
  end

  def self.schedule
    ChronoTrigger::Schedule.instance
  end

  def self.configure
    yield config
  end
end
