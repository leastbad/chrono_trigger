# frozen_string_literal: true

module ChronoTrigger
  class Config
    include Singleton
    attr_accessor :interval

    def initialize
      @interval = 0.1
    end
  end
end
