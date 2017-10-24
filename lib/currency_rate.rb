require "singleton"
require "json"

require "configuration"
require "adapter"

Dir["#{File.expand_path File.dirname(__FILE__)}/**/*.rb"].each { |f| require f }

module CurrencyRate
  class << self
    attr_writer :configuration
  end

  def self.configuration
    Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
