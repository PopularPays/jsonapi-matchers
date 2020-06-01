module Jsonapi
  module Matchers
    class RecordIncluded
      include Jsonapi::Matchers::Shared

      attr_reader :description

      def initialize(expected, location, description)
        @expected = expected
        @location = location
        @failure_message = nil
        @failure_message_when_negated = nil
        @description = description
      end

      def matches?(target)
        @target = normalize_target(target)
        return false unless @target

        case @location
        when 'data'
          target_location = @target[@location]
        when 'included'
          target_location = @target[@location]
        end

        case target_location
        when Array
          return target_location.any?{ |t| t.with_indifferent_access["id"] == @expected.id.to_s }
        when ::Hash
          return target_location.with_indifferent_access["id"] == @expected.id.to_s
        else
          @failure_message = "Expected value of #{@location} to be an Array or Hash but was #{target.inspect}"
          return false
        end
      end

      def failure_message
        @failure_message || "expected object with an id of '#{@expected.id}' to be included in #{@target.as_json.ai}"
      end

      def failure_message_when_negated
        @failure_message_when_negated || "expected object with an id of '#{@expected.id}' to not be included in #{@target.as_json.ai}"
      end
    end

    module Record
      def have_record(expected)
        RecordIncluded.new(expected, 'data', 'have record')
      end

      def include_record(expected)
        RecordIncluded.new(expected, 'included', 'include record')
      end
    end
  end
end
