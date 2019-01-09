module CurrencyRate
  class CoinMarketCapAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(
      ADA AE AION AOA ARDR ARK BAT BCD BCH BCN BCZERO BNB BNT BSV
      BTC BTG BTM BTS CNX CRO DAI DASH DCN DCR DEX DGB DGD DGTX DOGE
      ELA EOS ETC ETH ETN ETP FCT GNT GUSD HOT ICX INB IOST KCS KMD
      LINK LKY LRC LSK LTC MAID MANA MCO MGO MIOTA MKR MONA MXM NANO
      NEO NEXO NPXS ODE OMG ONT PAX PIVX POLY PPT QTUM RDD REP REPO
      RVN SNT STEEM STRAT TRX TUSD USDC USDT VET WAN WAVES WAX WTC
      XEM XIN XLM XMR XRP XTZ XVG XZC ZEC ZIL ZRX
    )

    ANCHOR_CURRENCY = "BTC"

    FETCH_URL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
    API_KEY_PARAM = "CMC_PRO_API_KEY"

    def normalize(data)
      return nil unless super
      data["data"].each_with_object({ "anchor" => ANCHOR_CURRENCY }) do |payload, result|
        if payload["symbol"] == ANCHOR_CURRENCY
          result["USD"] = BigDecimal.new(payload["quote"]["USD"]["price"].to_s)
        else
          result[payload["symbol"]] = result["USD"] / BigDecimal.new(payload["quote"]["USD"]["price"].to_s)
        end
      end
    end

  end
end
