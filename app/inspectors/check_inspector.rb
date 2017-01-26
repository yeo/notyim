# This wraps around assertion
require 'http_inspector'

class CheckInspector
  include Inspector::Http
  include Inspector::Tcp

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
    end
  end
end
