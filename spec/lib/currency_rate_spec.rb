require "spec_helper"

RSpec.describe CurrencyRate do
  it { is_expected.to respond_to(:configure) }
  it { is_expected.to respond_to(:sync!) }
end
