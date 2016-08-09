require "jsonapi/matchers/version"
require "active_support/json"
require 'awesome_print'

module Jsonapi
  module Matchers
    class IncludedInString
      def initialize(expected)
        @expected = expected
        @location = 'data'
        @failure_message = nil
      end

      def in(location)
        @location = location.to_s
        self
      end

      def matches?(target)
        @target = JSON.parse(target)
        @target[@location].try(:[], "id") == @expected.id
      rescue => e
        @failure_message = "Expect response to be json string but was #{target.inspect}"
        false
      end

      def failure_message
        @failure_message || "expected object with an id of '#{@expected.id}' be included in #{@target.as_json.ai}"
      end
    end

    class IncludedInResponse < IncludedInString
      def matches?(target)
        if target.is_a?(ActionController::TestResponse)
          super(target.body)
        else
          @failure_message = "Expect response to be ActionController::TestResponse with a body but was #{target.inspect}"
          false
        end
      end
    end

    module Response
      def include(expected)
        IncludedInResponse.new(expected)
      end
    end

    module String
      def include(expected)
        IncludedInString.new(expected)
      end
    end
  end
end
