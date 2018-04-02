$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'jsonapi/matchers'
require 'pry'


module ActionDispatch
  class TestResponse
    attr_accessor :body

    def initialize(body)
      self.body = body
    end
  end
end
