currency-rate
=============

Converter for fiat and crypto currencies. Currently supports BTC and LTC.

Installation
------------

    gem install currency-rate

or in Gemfile

    gem "currency-rate"

Configuration
-------------
```ruby
CurrencyRate.configure do |config|
    # Now only ForgeAdapter requires api key to fetch rates
    # Empty array by default
    config.api_keys["ForgeAdapter"] = "forge_api_key"

    # CurrencyRate::FileStorage configuration has only 'path' attribute
    config.file_storage[:path] = "/home/user/data" # default: ""

    # CurrencyRate uses default Logger from Ruby core library
    # It can be replaced with any compatible object
    # All logger values listed below are default
    config.logger[:device] = $stdout
    config.logger[:level] = :info
    config.logger[:formatter] = nil

    # Cryptocurrency exchange adapters to fetch
    config.crypto_adapters = ["Kraken", "Localbitcoins"]

    # Fiat exchange adapters to fetch
    config.fiat_adapters = ["Yahoo"]
end
```

Usage
-----

To fetch rates from exchanges into file storage (the only supported at this moment):
```ruby
CurrencyRate.sync!
```
This method will load all available data from exchanges and put into `yml` files. Failed exchanges will not create new / update exsisting files.

To get rates for Crypto/Fiat currency pair use:
```ruby
CurrencyRate.fetch_crypto("Bitstamp", "BTC", "USD")
```

For fetching Fiat/Fiat pair:
```ruby
CurrencyRate.fetch_fiat("CNY", "USD")
```

Details
-------

`CurrencyRate` contains two parts that can work independently: Synchronizer and Fetcher.
`CurrencyRate::Synchronizer` loads data from selected exchanges using adapters and saves it into FileStorage in normalized format.
`CurrencyRate::Fetch` reads data from FileStorage and returns rate for requested pair and exchange.
