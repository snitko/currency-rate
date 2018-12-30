Gem::Specification.new do |s|
  s.name = "currency-rate".freeze
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Roman Snitko".freeze]
  s.date = "2018-12-30"
  s.description = "Fetches exchange rates from various sources and does the conversion".freeze
  s.email = "roman.snitko@gmail.com".freeze
  s.executables = ["rake".freeze, "rspec".freeze]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "api_keys.yml.sample",
    "bin/rake",
    "bin/rspec",
    "currency-rate.gemspec",
    "lib/adapter.rb",
    "lib/adapters/crypto/binance_adapter.rb",
    "lib/adapters/crypto/bitfinex_adapter.rb",
    "lib/adapters/crypto/bitpay_adapter.rb",
    "lib/adapters/crypto/bitstamp_adapter.rb",
    "lib/adapters/crypto/btc_china_adapter.rb",
    "lib/adapters/crypto/btc_e_adapter.rb",
    "lib/adapters/crypto/coinbase_adapter.rb",
    "lib/adapters/crypto/exmo_adapter.rb",
    "lib/adapters/crypto/huobi_adapter.rb",
    "lib/adapters/crypto/kraken_adapter.rb",
    "lib/adapters/crypto/localbitcoins_adapter.rb",
    "lib/adapters/crypto/okcoin_adapter.rb",
    "lib/adapters/fiat/currency_layer_adapter.rb",
    "lib/adapters/fiat/fixer_adapter.rb",
    "lib/adapters/fiat/forge_adapter.rb",
    "lib/adapters/fiat/free_forex_adapter.rb",
    "lib/adapters/fiat/yahoo_adapter.rb",
    "lib/configuration.rb",
    "lib/currency_rate.rb",
    "lib/fetcher.rb",
    "lib/storage/file_storage.rb",
    "lib/storage/serializers/yaml_serializer.rb",
    "lib/synchronizer.rb",
    "spec/fixtures/adapters/binance_rates.yml",
    "spec/fixtures/adapters/bitfinex_rates.yml",
    "spec/fixtures/adapters/bitpay_rates.yml",
    "spec/fixtures/adapters/bitstamp_rates.yml",
    "spec/fixtures/adapters/btc_china_rates.yml",
    "spec/fixtures/adapters/btce_rates.yml",
    "spec/fixtures/adapters/coinbase_rates.yml",
    "spec/fixtures/adapters/currency_layer_rates.yml",
    "spec/fixtures/adapters/exmo_rates.yml",
    "spec/fixtures/adapters/fixer_rates.yml",
    "spec/fixtures/adapters/forge_rates.yml",
    "spec/fixtures/adapters/free_forex_rates.yml",
    "spec/fixtures/adapters/huobi_rates.yml",
    "spec/fixtures/adapters/kraken_rates.yml",
    "spec/fixtures/adapters/localbitcoins_rates.yml",
    "spec/fixtures/adapters/normalized/binance_rates.yml",
    "spec/fixtures/adapters/normalized/bitfinex_rates.yml",
    "spec/fixtures/adapters/normalized/bitpay_rates.yml",
    "spec/fixtures/adapters/normalized/bitstamp_rates.yml",
    "spec/fixtures/adapters/normalized/btc_china_rates.yml",
    "spec/fixtures/adapters/normalized/btce_rates.yml",
    "spec/fixtures/adapters/normalized/coinbase_rates.yml",
    "spec/fixtures/adapters/normalized/currency_layer_rates.yml",
    "spec/fixtures/adapters/normalized/exmo_rates.yml",
    "spec/fixtures/adapters/normalized/fixer_rates.yml",
    "spec/fixtures/adapters/normalized/forge_rates.yml",
    "spec/fixtures/adapters/normalized/free_forex_rates.yml",
    "spec/fixtures/adapters/normalized/huobi_rates.yml",
    "spec/fixtures/adapters/normalized/kraken_rates.yml",
    "spec/fixtures/adapters/normalized/localbitcoins_rates.yml",
    "spec/fixtures/adapters/normalized/okcoin_rates.yml",
    "spec/fixtures/adapters/normalized/yahoo_rates.yml",
    "spec/fixtures/adapters/okcoin_rates.yml",
    "spec/fixtures/adapters/yahoo_rates.yml",
    "spec/lib/adapter_spec.rb",
    "spec/lib/adapters/crypto/binance_adapter_spec.rb",
    "spec/lib/adapters/crypto/bitfinex_adapter_spec.rb",
    "spec/lib/adapters/crypto/bitpay_adapter_spec.rb",
    "spec/lib/adapters/crypto/bitstamp_adapter_spec.rb",
    "spec/lib/adapters/crypto/btc_china_adapter_spec.rb",
    "spec/lib/adapters/crypto/btc_e_adapter_spec.rb",
    "spec/lib/adapters/crypto/coinbase_adapter_spec.rb",
    "spec/lib/adapters/crypto/exmo_adapter_spec.rb",
    "spec/lib/adapters/crypto/huobi_adapter_spec.rb",
    "spec/lib/adapters/crypto/kraken_adapter_spec.rb",
    "spec/lib/adapters/crypto/localbitcoins_adapter_spec.rb",
    "spec/lib/adapters/crypto/okcoin_adapter_spec.rb",
    "spec/lib/adapters/fiat/currency_layer_adapter_spec.rb",
    "spec/lib/adapters/fiat/fixer_adapter_spec.rb",
    "spec/lib/adapters/fiat/forge_adapter_spec.rb",
    "spec/lib/adapters/fiat/free_forex_adapter_spec.rb",
    "spec/lib/adapters/fiat/yahoo_adapter_spec.rb",
    "spec/lib/currency_rate_spec.rb",
    "spec/lib/fetcher_spec.rb",
    "spec/lib/storage/file_storage_spec.rb",
    "spec/lib/synchronizer_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/matchers/eq_any_of.rb"
  ]
  s.homepage = "http://github.com/snitko/currency-rate".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Converter for fiat and crypto currencies".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<http>.freeze, [">= 0"])
      s.add_development_dependency(%q<byebug>.freeze, [">= 0"])
      s.add_development_dependency(%q<jeweler>.freeze, ["~> 2.3.7"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<webmock>.freeze, [">= 0"])
    else
      s.add_dependency(%q<http>.freeze, [">= 0"])
      s.add_dependency(%q<byebug>.freeze, [">= 0"])
      s.add_dependency(%q<jeweler>.freeze, ["~> 2.3.7"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<webmock>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<http>.freeze, [">= 0"])
    s.add_dependency(%q<byebug>.freeze, [">= 0"])
    s.add_dependency(%q<jeweler>.freeze, ["~> 2.3.7"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, [">= 0"])
  end
end

