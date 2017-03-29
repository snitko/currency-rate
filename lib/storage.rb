module CurrencyRate
  class Storage

    attr_reader :data

    def initialize(adapter_name: nil, timeout: 1800)
      @timeout      = timeout
      @data         = {}
      @adapter_name = adapter_name
    end

    def fetch(key)
      if @data[key].nil? || (@data[key][:timestamp] < (Time.now.to_i - @timeout))
        @data[key] = { content: yield, timestamp: Time.now.to_i }
      end
      @data[key][:content]
    end

  end
end
