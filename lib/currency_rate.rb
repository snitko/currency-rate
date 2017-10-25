require "singleton"
require "json"

require "configuration"
require "adapter"
require "synchronizer"

Dir["#{File.expand_path File.dirname(__FILE__)}/**/*.rb"].each { |f| require f }

module CurrencyRate
  class << self
    attr_writer :configuration
  end

  def self.method_missing(m, *args, &block)
    if m.to_s.end_with? "_adapters"
      self.send(:adapters, m[0..-10])
    else
      super
    end
  end

  def self.adapters(type)
    Dir[File.join self.root, "lib/adapters/#{type}"].map do |file|
      File.basename(file, ".rb").camelize
    end
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

  def self.sync!
    synchronizer.sync!
  end

  def self.root
    File.expand_path("../", File.dirname(__FILE__))
  end
end
