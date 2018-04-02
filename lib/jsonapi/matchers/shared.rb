module Jsonapi
  module Matchers
    module Shared
      def normalize_target(target)
        if test_response?(target)
          begin
            JSON.parse(target.body).with_indifferent_access
          rescue => e
            @failure_message = "Expected response to be json string but was #{target.body.inspect}. #{e.class} - #{e.message}"
            return
          end
        elsif target.is_a?(Hash)
          return target.with_indifferent_access
        else
          @failure_message = "Expected response to be ActionDispatch::TestResponse, ActionController::TestResponse, or hash but was #{target.inspect}"
          return
        end
      end

      private

      def test_response?(target)
        defined?(::ActionDispatch::TestResponse) && target.is_a?(::ActionDispatch::TestResponse) ||
          defined?(::ActionController::TestResponse) && target.is_a?(::ActionController::TestResponse)
      end
    end
  end
end
