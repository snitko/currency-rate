module CurrencyRate
  class FileStorage
    attr_reader   :path
    attr_accessor :serializer

    def initialize(path = nil, serializer: nil)
      @path       ||= CurrencyRate.configuration.file_storage[:path]
      @serializer ||= Storage::YAMLSerializer.new
    end

    def read(exchange_name)
      @serializer.deserialize File.read(path_for exchange_name)
    end

    def write(exchange_name, data = "")
      File.write path_for(exchange_name), @serializer.serialize(data)
    end

    def path_for(exchange_name)
      File.join @path, "#{exchange_name}_rates.yml"
    end
  end
end
