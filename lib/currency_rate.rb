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
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.synchronizer
    @synchronizer ||= Synchronizer.new
  end

  def self.sync
    synchronizer.sync!
  end

  def self.root
    File.expand_path("../", File.dirname(__FILE__))
  end
end
