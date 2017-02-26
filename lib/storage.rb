module CurrencyRate
  class Storage

    def initialize(timeout: 1800)
      @timeout     = timeout
      @mem_storage = {}
    end

    def fetch(key, force_from_storage: false)
      if !force_from_storage && (@mem_storage[key].nil? || (@mem_storage[key][:timestamp] < (Time.now.to_i - @timeout)))
        @mem_storage[key] = { content: yield, timestamp: Time.now.to_i }
      end
      @mem_storage[key][:content]
    end

  end
end
