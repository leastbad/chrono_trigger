# frozen_string_literal: true

require File.expand_path("../lib/chrono_trigger/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "chrono_trigger"
  gem.license = "MIT"
  gem.version = ChronoTrigger::VERSION
  gem.authors = ["leastbad"]
  gem.email = ["hello@leastbad.com"]
  gem.homepage = "https://github.com/leastbad/chrono_trigger"
  gem.summary = "A clock for Rails"

  gem.files = Dir["lib/**/*.rb", "bin/*", "[A-Z]*"]

  gem.add_dependency "rails", ">= 5.2"
  gem.add_dependency "thread-local", ">= 1.1.0"

  gem.add_development_dependency "magic_frozen_string_literal"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-nav"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "standardrb"
end