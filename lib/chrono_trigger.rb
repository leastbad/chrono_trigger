# frozen_string_literal: true

require "rails/engine"
require "active_support/all"
require "chrono_trigger/clock"
require "chrono_trigger/config"
require "chrono_trigger/event"
require "chrono_trigger/timeline"
require "chrono_trigger/version"

module ChronoTrigger
  class Engine < Rails::Engine
  end

  def self.config
    ChronoTrigger::Config.instance
  end

  def self.configure
    yield config
  end
end
