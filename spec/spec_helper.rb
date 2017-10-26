require "yaml"
require "byebug"
require "webmock/rspec"

require_relative "../lib/currency_rate"

Dir[File.join CurrencyRate.root, "spec/support/**/*.rb"].each { |f| require f }

def exchange_data_for(name)
  YAML.load_file File.join(CurrencyRate.root, "spec/fixtures/adapters/#{name}_adapter.yml")
end

def normalized_data_for(name)
  floating = YAML.load_file File.join(CurrencyRate.root, "spec/fixtures/adapters/normalized/#{name}_adapter.yml")
  floating.each { |k, v| floating[k] = BigDecimal.new(v.to_s) if k != "anchor" }
end

def data_for(name)
  [exchange_data_for(name), normalized_data_for(name)]
end

RSpec.configure do |config|
  config.default_formatter = "doc"
end
