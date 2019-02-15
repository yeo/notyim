# frozen_string_literal: true

require 'inspector/eval'
require 'inspector/http'

class CheckInspector
  include Inspector::Http

  attr_reader :assertion, :check_response

  def initialize(assertion)
    @assertion = assertion
  end

  # Check whether the result match an assertion
  # @param CheckResponse
  def match?(check_response)
    case @assertion.check.type
    when Check::TYPE_HTTP
      check_http(assertion, check_response)
    else raise "Unsupport check type #{@assertion.check.type}"
    end
  end
end
