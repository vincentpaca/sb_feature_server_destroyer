module CommandRunner
  module Util
    class ArgumentDefinition
      class Item
        def initialize(name, options)
          @name = name
          @default = options.key?(:default) ? options[:default] : :__none
          @transform = options[:transform]
        end

        def has_default?
          default != :__none
        end

        def required?
          !has_default?
        end

        attr_reader :name, :default, :transform
      end

      class Value
        def initialize(item, value)
          @item = item
          @value = value
        end

        def missing?
          value.nil? && @item.required?
        end

        def value
          @value.nil? ? default_or_nil : transformed_raw_value
        end

        private

        def default_or_nil
          @item.has_default? ? @item.default : nil
        end

        def transformed_raw_value
          @item.transform ? @item.transform.(@value) : @value
        end
      end

      def self.define(&block)
        new.define(&block)
      end

      def initialize
        @arguments = []
      end

      def argument_info
        'Arguments: ' + arguments.map { |arg|
          if arg.has_default?
            "[#{arg.name}=#{arg.default}]"
          else
            "#{arg.name}"
          end
        }.join(' ')
      end

      attr_reader :arguments

      def define
        yield(self)
        self
      end

      def add(name, options = {})
        @arguments << Item.new(name, options)
      end
    end
  end
end
