require 'byebug'
require 'yaml'
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative "lib/currency_rate"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

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
