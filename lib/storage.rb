module CurrencyRate
  class Storage

    def initialize(timeout: 1800)
      @timeout     = timeout
      @mem_storage = {}
    end

    def fetch(key)
      if @mem_storage[key].nil? || (@mem_storage[key][:timestamp] < (Time.now.to_i - @timeout))
        @mem_storage[key] = { content: yield, timestamp: Time.now.to_i }
      end
      @mem_storage[key][:content]
    end

  end
end
