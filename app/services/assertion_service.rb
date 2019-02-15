# frozen_string_literal: true

class AssertionService
  attr_reader :assertion
  def initialize(assertion)
    @assertion = assertion
  end
end
