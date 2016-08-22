module Jsonapi
  module Matchers
    class AttributesIncluded
      include Jsonapi::Matchers::Shared

      def initialize(attribute_name, location)
        @attribute_name = attribute_name
        @location = location
        @failure_message = nil
      end

      def with_value(expected_value)
        @expected_value = expected_value
        self
      end

      def matches?(target)
        @target = normalize_target(target)
        return false unless @target

        if @location
          @target = target.try(:[], :data).try(:[], @location).with_indifferent_access
        else
          @target = target.try(:[], :data).with_indifferent_access
        end

        @value = @target.try(:[], @attribute_name)


        if @expected_value
          if @expected_value.to_s == @value.to_s
            return true
          else
            @failure_message = "expected '#{@expected_value}' for key '#{@attribute_name}', but got '#{@value}'"
            return false
          end
        else
          !!@value
        end
      end

      def failure_message
        @failure_message || "expected attribute '#{@attribute_name}' to be included in #{@target.as_json.ai}"
      end
    end

    module Attributes
      def have_id(id)
        AttributesIncluded.new('id', nil).with_value(id)
      end

      def have_type(type)
        AttributesIncluded.new('type', nil).with_value(type)
      end

      def have_attribute(attribute_name)
        AttributesIncluded.new(attribute_name, :attributes)
      end
    end
  end
end
