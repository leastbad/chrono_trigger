# frozen_string_literal: true

require File.expand_path("../lib/chrono_trigger/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "chrono_trigger"
  gem.license = "MIT"
  gem.version = ChronoTrigger::VERSION
  gem.authors = ["leastbad"]
  gem.email = ["hello@leastbad.com"]
  gem.homepage = "https://chronotrigger.leastbad.com/"
  gem.summary = "A clock-based scheduler that runs inside your Rails app."
  gem.metadata = {
    "source_code_uri" => "https://github.com/leastbad/chrono_trigger",
    "documentation_uri" => "https://chronotrigger.leastbad.com/"
  }

  gem.files = Dir["lib/**/*.rb", "bin/*", "[A-Z]*"]

  gem.add_dependency "rails", ">= 5.2"
  gem.add_dependency "concurrent-ruby", "~> 1.1", ">= 1.1.8"
  gem.add_dependency "concurrent-ruby-edge", "~> 0.6", ">= 0.6.0"

  gem.add_development_dependency "magic_frozen_string_literal", "~> 1.2.0"
  gem.add_development_dependency "pry", "~> 0.12"
  gem.add_development_dependency "pry-nav", "~> 0.3"
  gem.add_development_dependency "rake", "~> 13.0", ">= 13.0.3"
  gem.add_development_dependency "standardrb", "~> 1.0"
end
