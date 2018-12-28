module CurrencyRate
  class BitfinexAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(
      AGI AID AIO ANT ATM AUC AVT BAB BAT BCI BFT BNT BSV BTG CBT CFI CND CTX
      DAD DAI DAT DGB DASH DTA DTH EDO ELF EOS ESS ETC ETH ETP EUR FSN FUN GBP
      GNT HOT IOS IOT IQX JPY KNC LRC LTC LYM MIT MKR MNA MTN NCA NEO ODE OMG
      OMNI ORS PAI POA POY QSH QTM RBT RCN RDN REP REQ RLC RRT SAN SEE SEN SNG
      SNT SPK STJ TNB TRX USD UTK VEE VET WAX WPR XLM XMR XRP XTZ XVG YYW ZCN
      ZEC ZIL ZRX
    )

    ASSET_MAP = {
                  "DSH" => "DASH",
                  "OMN" => "OMNI",
                }

    ANCHOR_CURRENCY = "BTC"

    FETCH_URL = "https://api.bitfinex.com/v2/tickers?symbols=ALL"

    def normalize(data)
      return nil unless super
      data.reduce({ "anchor" => ANCHOR_CURRENCY }) do |result, pair_info|
        pair_name = pair_info[0].sub("t", "")
        key = pair_name.sub(ANCHOR_CURRENCY, "")
        key = ASSET_MAP[key] || key

        if pair_name.index(ANCHOR_CURRENCY) == 0
          result[key] = BigDecimal.new(pair_info[7].to_s)
        elsif pair_name.index(ANCHOR_CURRENCY) == 3
          result[key] = 1 / BigDecimal.new(pair_info[7].to_s)
        end

        result
      end
    end

  end
end
