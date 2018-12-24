module CurrencyRate
  class ExmoAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(
      ADA BCH BTC BTCZ BTG DASH DOGE DXT EOS ETC ETH EUR GAS GNT GUSD HB
      HBZ INK KICK LSK LTC MNX NEO OMG PLN QTUM RUB SMART STQ TRX TRY UAH
      USD USDT WAVES XEM XLM XMR XRP ZEC ZRX
    )

    ANCHOR_CURRENCY = "BTC"

    FETCH_URL = "https://api.exmo.com/v1/ticker/"

    def normalize(data)
      return nil unless super
      data.reduce({ "anchor" => ANCHOR_CURRENCY }) do |result, (key, value)|
        if key.split("_")[0] == ANCHOR_CURRENCY
          result[key.sub("#{self.class::ANCHOR_CURRENCY}_", "")] = BigDecimal.new(value["avg"].to_s)
        elsif key.split("_")[1] == ANCHOR_CURRENCY
          result[key.sub("_#{self.class::ANCHOR_CURRENCY}", "")] = 1 / BigDecimal.new(value["avg"].to_s)
        end
        result
      end
    end

  end
end
