require "yaml"

module CurrencyRate
  module Storage
    class YAMLSerializer
      def serialize(data)
        YAML.dump(data)
      end

      def deserialize(data)
        YAML.load(data)
      end
    end
  end
end
