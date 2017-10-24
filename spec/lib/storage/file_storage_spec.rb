require "spec_helper"

RSpec.describe CurrencyRate::FileStorage do
  before do
    @data = { "key" => "value" }
    @serializer = CurrencyRate::Storage::YAMLSerializer.new
    @serialized_data = @serializer.serialize(@data)
    @storage = CurrencyRate::FileStorage.new(serializer: @serializer)
  end

  describe "#read" do
    before do
      allow(File).to receive(:read).and_return(@serialized_data)
    end

    it "returns deserialized data from file" do
      expect(@storage.read("exchange")).to eq(@data)
    end
  end

  describe "#write" do
    it "writes serialized data to file" do
      expect(File).to receive(:write).with(kind_of(String), @serialized_data)
      @storage.write("exchange", @data)
    end
  end
end
