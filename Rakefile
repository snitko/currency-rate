# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "currency-rate"
  gem.homepage = "http://github.com/snitko/currency-rate"
  gem.license = "MIT"
  gem.summary = %Q{Converter for fiat and crypto currencies}
  gem.description = %Q{Fetches exchange rates from various sources and does the conversion}
  gem.email = "roman.snitko@gmail.com"
  gem.authors = ["Roman Snitko"]
end

require 'byebug'
require 'yaml'
require_relative "lib/currency_rate"

desc "Update rates for specified adapter"
task :update_rates, [:exchange] do |t, args|
  api_keys = YAML.load_file("api_keys.yml")

  CurrencyRate.configure do |config|
    api_keys.each { |name, key| config.api_keys[name] = key }
  end

  adapter = CurrencyRate::const_get("#{args.exchange}Adapter").instance

  print "Loading data for #{args.exchange}... "
  exchange_data = adapter.exchange_data
  raw_storage = CurrencyRate::FileStorage.new(File.expand_path("spec/fixtures/adapters", __dir__))
  raw_storage.write(args.exchange, exchange_data)
  puts "Success!"

  print "Normalizing data for #{args.exchange}..."
  normalized_data = adapter.normalize exchange_data
  normalized_storage = CurrencyRate::FileStorage.new(File.expand_path("spec/fixtures/adapters/normalized", __dir__))
  normalized_storage.write(args.exchange, normalized_data)
  puts "Success!"

  puts "#{args.exchange} fixtures update finished!"
end
