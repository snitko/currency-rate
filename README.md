currency-rate
=============

Converter for fiat and crypto currencies

Installation
------------

    gem install currency-rate

or in Gemfile

    gem "currency-rate"

Usage
-----
Basically, all you'll need is to use the top level class to fetch any rates you want.
For example:

    CurrencyRate.convert('Bitstamp', amount: 5, from: 'BTC', to: 'USD')
    CurrencyRate.convert('Bitstamp', amount: 2750, from: 'USD', to: 'BTC')
    CurrencyRate.convert('Bitstamp', amount: 1000, from: 'USD', to: 'EUR')

In the third case, because Bitstamp doesn't really support direct conversion from
USD to EUR, the 1000 will first be converted to BTC, then the BTC amount will be converted to EUR.

This introduced the concept of anchor currency. For all Btc adapters in this lib, it's set to BTC
by default. For all Fiat adapters it's set to USD by default. To specify anchor currency manually,
simply pass it as another argument, for example:

    CurrencyRate.convert('Bitstamp', amount: 1000, from: 'USD', to: 'EUR', anchor_currency: 'BTC')

You can also use `#get` method to get just the rate. It basically works as `#convert`, but only returns the rate and the method signature (attributes passed) is different - attributes are not named:

    CurrencyRate.get('Bitstamp', 'BTC', 'USD') # => 750
    CurrencyRate.get('Bitstamp', 'USD', 'BTC') # => 0.001818182

In the second case, we are trying to get the exchange rate for USD/BTC pair, which literally means
"how much in BTC would 1 USD be?". If the source (Bitstamp, in this case) doesn't provide the
inverted rate, the Adapter inverts the rate itself using the exchange rate for BTC/USD.

You can also using `anchor_currency` with `#get`:

    CurrencyRate.get('Bitstamp', 'USD', 'EUR', anchor_currency: 'BTC')

For a list of available adapters, please see
[lib/btc_adapters](https://github.com/snitko/currency-rate/tree/master/lib/btc_adapters)
and [lib/fiat_adapters](https://github.com/snitko/currency-rate/tree/master/lib/fiat_adapters).
To specify an adapter for `#convert` or `#get`, remove the last `Adapter` part from its name.

Caching and Storage
-------------------

By default, a simple in-memory caching mechanism with a timeout of 1800 seconds is set.
To change the default timeout and also implement your very own caching mechanism you can
try reloading `CurrencyRate::Storage` methods and writing your own functionality,
storing data in Redis, for example.

While I agree it'd be nicer to have the timeout set somewhere in `CurrencyRate` class,
for simplicity reasons I've avoided that. It also makes sense that the `Storage` class is responsible
for how and when to store/fetch data, not other classes.

Credits
-------
This gem was extracted from [straight gem](https://github.com/MyceliumGear/straight), thanks to all the people who added various exchange rate adapters and contributed code.
