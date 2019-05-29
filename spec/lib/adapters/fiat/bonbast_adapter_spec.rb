require "spec_helper"

RSpec.describe CurrencyRate::BonbastAdapter do
  before { stub_request(:get, /bonbast/).to_return(body: File.read(File.join(CurrencyRate.root, "spec/fixtures/adapters/bonbast.html"))) }
  before { @adapter = CurrencyRate::BonbastAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.fetch_rates).to eq({ "anchor" => "USD", "IRR" => BigDecimal.new("137000.0") })
    end
  end

end
