require 'spec_helper'

describe CurrencyRate::Storage do

  before(:each) do
    @source = double("Source") # source object from which the data is received
    @storage = CurrencyRate::Storage.new
  end

  it "fetches from storage when timestamp isn't expired" do
    expect(@source).to receive(:get).once.and_return('hi')
    @storage.fetch('hello_world') { @source.get }
    expect(@storage.fetch('hello_world')).to eq('hi')
  end

  it "runs a passed block to receive new result when timestamp is expired" do
    expect(@source).to receive(:get).twice.and_return('hi', 'hello')
    @storage.fetch('hello_world') { @source.get }
    @storage.instance_variable_set(:@timeout, -1)
    @storage.fetch('hello_world') { @source.get }
    @storage.instance_variable_set(:@timeout, 1800)
    expect(@storage.fetch('hello_world') { '' }).to eq('hello')
  end

  it "fetches from storage regardless if the timestamp expired if :force_from_storage is true" do
    allow(@source).to receive(:get).twice.and_return('hi', 'hello')
    @storage.fetch('hello_world') { @source.get }
    @storage.instance_variable_set(:@timeout, 1800)
    expect(@storage.fetch('hello_world') { '' }).to eq('hi')
  end
  
end
