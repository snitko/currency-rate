module CurrencyRate
  class BinanceAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(
      ADA ADX AGI AMB ARK ARN AST BAT BCC BCD BCN BLZ BNB BNT BQX
      BRD BTG BTS CDT CMT CND CVC DCR DGD DLT DNT EDO ELF ENG ENJ
      EOS ETC ETH EVX FUN GAS GNT GRS GTO GVT GXS HOT HSR ICN ICX
      INS KEY KMD KNC LRC LSK LTC LUN MCO MDA MFT MOD MTH MTL NAS
      NAV NEO NXS OAX OMG ONT OST PAX PHX POA POE PPT QKC QLC QSP
      RCN RDN REN REP REQ RLC RPX RVN SKY SNM SNT SUB SYS TNB TNT
      TRX USDC USDT VEN VET VIA VIB WAN WPR WTC XEM XLM XMR XRP
      XVG XZC ZEC ZEN ZIL ZRX
    )

    ANCHOR_CURRENCY = "BTC"

    FETCH_URL = {
                  "Binance" => "https://api.binance.com/api/v3/ticker/price",
                  "Blockchain" => "https://blockchain.info/ticker"
                }

    def normalize(data)
      return nil unless super
      binance_result = data["Binance"].reduce({ "anchor" => ANCHOR_CURRENCY }) do |result, hash|
        if hash["symbol"].index(ANCHOR_CURRENCY) == 0
          result[hash["symbol"].sub(ANCHOR_CURRENCY, "")] = BigDecimal.new(hash["price"].to_s)
        elsif hash["symbol"].index(ANCHOR_CURRENCY) == 3
          result[hash["symbol"].sub(ANCHOR_CURRENCY, "")] = 1 / BigDecimal.new(hash["price"].to_s)
        end
        result
      end

      blockchain_result = data["Blockchain"].reduce({}) do |result, (key, value)|
        result[key] = BigDecimal.new(value["last"].to_s)
        result
      end

      binance_result.merge(blockchain_result)
    end

  end
end
