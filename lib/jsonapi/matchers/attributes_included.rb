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
        @check_value = true
        @expected_value = expected_value
        self
      end

      def with_record(expected_record)
        @check_record = true
        @expected_record_id = expected_record.id
        self
      end

      def matches?(target)
        @target = normalize_target(target)
        return false unless @target

        if @location
          @target = @target.try(:[], :data).try(:[], @location)
        else
          @target = @target.try(:[], :data)
        end

        @value = @target.try(:[], @attribute_name)

        if @check_value
          value_exists?
        elsif @check_record
          record_exists?
        else
          @target.key?(@attribute_name)
        end
      end

      def failure_message
        @failure_message || "expected attribute '#{@attribute_name}' to be included in #{@target.as_json.ai}"
      end

      private

      def value_exists?
        if @expected_value.to_s == @value.to_s
          true
        else
          @failure_message = "expected '#{@expected_value}' for key '#{@attribute_name}', but got '#{@value}'"
          false
        end
      end

      def record_exists?
        data = @value.try(:[], 'data')

        if data.is_a?(Array)
          if data.map{|d| d['id']}.include?(@expected_record_id)
            return true
          else
            @failure_message = "expected '#{@expected_record_id}' to be the an id in relationship '#{@attribute_name}', but got '#{@value['data']}'"
            return false
          end
        elsif @expected_record_id == @value.try(:[], 'data').try(:[], 'id')
          return true
        else
          @failure_message = "expected '#{@expected_record_id}' to be the id for relationship '#{@attribute_name}', but got '#{@value}'"
          return false
        end
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

      def have_relationship(relationship_name)
        AttributesIncluded.new(relationship_name, :relationships)
      end
    end
  end
end
