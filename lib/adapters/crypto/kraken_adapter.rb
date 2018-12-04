module CurrencyRate
  class KrakenAdapter < Adapter
    USD = "usd"
    CRYPTOS = ["btc","ltc","xrp","eth","etc","zec","xmr","eos","dash"]

    ASSET_MAP = {
                  "BTC" => "XBT",
                  "XBT" => "BTC",
                }

    FETCH_URL = Hash[CRYPTOS.collect { |crypto| [ "#{crypto}_#{USD}".upcase, "https://api.kraken.com/0/public/Ticker?pair=#{ASSET_MAP[crypto.upcase]&.downcase || crypto}#{USD}" ] }]

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (pair, value)|
        crypto, fiat = pair.split("_")
        begin
          result[pair] = BigDecimal.new(value["result"]["X#{ta(crypto)}Z#{ta(fiat)}"]["c"].first.to_s)
        rescue NoMethodError => e
          result[pair] = BigDecimal.new(value["result"]["#{ta(crypto)}#{ta(fiat)}"]["c"].first.to_s)
        end
        result
      end
    end

    def translate_asset(asset)
      ASSET_MAP[asset] || asset
    end
    alias_method :ta, :translate_asset

  end
end
