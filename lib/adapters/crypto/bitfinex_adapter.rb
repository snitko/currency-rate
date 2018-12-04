module CurrencyRate
  class BitfinexAdapter < Adapter
    USD = "usd"
    CRYPTOS = [
                "btc","ltc","xrp","eth","etc","xtz","zec","xmr","eos","btg","etp",
                "trx","iqx","xvg","vet","dgb","aio","bci","omn","pai","dsh"
              ]

    ASSET_MAP = {
                  "DSH" => "DASH",
                }

    FETCH_URL = Hash[CRYPTOS.collect { |crypto| [ "#{ASSET_MAP[crypto.upcase] || crypto}_#{USD}".upcase, "https://api.bitfinex.com/v1/pubticker/#{crypto}#{USD}" ] }]

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (pair, value)|
        result[pair] = BigDecimal.new(value["last_price"].to_s)
        result
      end
    end

  end
end
