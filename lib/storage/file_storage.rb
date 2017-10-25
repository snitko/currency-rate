module CurrencyRate
  class FileStorage
    attr_reader   :path
    attr_accessor :serializer

    def initialize(path = nil, serializer: nil)
      @path       ||= CurrencyRate.configuration.file_storage[:path]
      @serializer ||= Storage::YAMLSerializer.new
    end

    def read(exchange_name)
      path = path_for exchange_name.downcase
      return nil unless File.exist?(path)
      @serializer.deserialize File.read(path)
    end

    def write(exchange_name, data = "")
      File.write path_for(exchange_name.downcase), @serializer.serialize(data)
    end

    def path_for(exchange_name)
      File.join @path, "#{exchange_name}_rates.yml"
    end
  end
end
