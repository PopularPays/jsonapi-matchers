require "jsonapi/matchers/version"
require "active_support/json"
require 'awesome_print'

module Jsonapi
  module Matchers
    class IncludedInString
      def initialize(expected, location)
        @expected = expected
        @location = location
        @failure_message = nil
      end

      def matches?(target)
        begin
          @target = JSON.parse(target)
        rescue
          @failure_message = "Expected response to be json string but was #{target.inspect}"
          return false
        end

        case @location
        when 'data'
          target_location = @target[@location]
        when 'included'
          target_location = @target[@location]
        end

        case target_location
        when Array
          return target_location.any?{|t| t["id"] == @expected.id}
        when Hash
          return target_location["id"] == @expected.id
        else
          @failure_message = "Expected value of #{@location} to be an Array or Hash but was #{target.inspect}"
          return false
        end
      end

      def failure_message
        @failure_message || "expected object with an id of '#{@expected.id}' to be included in #{@target.as_json.ai}"
      end
    end

    class IncludedInResponse < IncludedInString
      def matches?(target)
        if target.is_a?(ActionController::TestResponse)
          super(target.body)
        else
          @failure_message = "Expected response to be ActionController::TestResponse with a body but was #{target.inspect}"
          false
        end
      end
    end

    module Response
      def have_record(expected)
        IncludedInResponse.new(expected, 'data')
      end

      def include_record(expected)
        IncludedInResponse.new(expected, 'included')
      end
    end

    module String
      def have_record(expected)
        IncludedInString.new(expected, 'data')
      end

      def include_record(expected)
        IncludedInString.new(expected, 'included')
      end
    end
  end
end
