module CurrencyRate
  class BitfinexAdapter < Adapter
    CRYPTOS = %w[
                  aio bci btc btg dgb dsh eos etc eth etp iqx
                  ltc omn pai trx vet xmr xrp xtz xvg zec
                ]

    ASSET_MAP = {
                  "DSH" => "DASH",
                  "OMN" => "OMNI",
                }

    FETCH_URL = Hash[CRYPTOS.collect { |crypto| [ "#{ASSET_MAP[crypto.upcase] || crypto}_usd".upcase, "https://api.bitfinex.com/v1/pubticker/#{crypto}usd" ] }]

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (pair, value)|
        result[pair] = BigDecimal.new(value["last_price"].to_s)
        result
      end
    end

  end
end
