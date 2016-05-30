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
