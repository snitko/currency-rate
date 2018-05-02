require "bigdecimal"
require "logger"
require "singleton"
require "json"
require "http"

require "configuration"
require "adapter"
require "fetcher"
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
    Dir[File.join self.root, "lib/adapters/#{type}/*"].map do |file|
      File.basename(file, ".rb").split('_').map {|w| w.capitalize}.join
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.fetcher
    @fetcher ||= Fetcher.new(fiat_exchanges: configuration.fiat_adapters)
  end

  def self.fetch_crypto(exchange, from, to)
    fetcher.fetch_crypto(exchange, from, to)
  end

  def self.fetch_fiat(from, to)
    fetcher.fetch_fiat(from, to)
  end

  def self.logger
    return @logger if @logger
    @logger = Logger.new(configuration.logger[:device])
    @logger.progname = "CurrencyRate"
    @logger.level = configuration.logger[:level]
    @logger.formatter = configuration.logger[:formatter] if configuration.logger[:formatter]
    @logger
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
