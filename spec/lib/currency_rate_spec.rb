require "spec_helper"

RSpec.describe CurrencyRate do
  it { is_expected.to respond_to(:configure) }
  it { is_expected.to respond_to(:sync!) }
  it { is_expected.to respond_to(:fetch_crypto) }
  it { is_expected.to respond_to(:fetch_fiat) }
  it { is_expected.to respond_to(:logger) }
end
