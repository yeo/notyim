# frozen_string_literal: true

module Inspector
  module Http
    # Check the response matches an assertion
    def check_http(assertion, check_response)
      _check_type, check_property = assertion.subject.split('.')
      case assertion.condition
      when 'up', 'down'
        ::Inspector::Eval.send(assertion.condition, check_response)
      when 'slow'
        ::Inspector::Eval.slow(check_response, 9000)
      when 'eq', 'ne', 'gt', 'lt', 'contain', 'in'
        evaluate_on_propery(check_property, assertion, check_response)
      end
    end

    def evaluate_on_propery(check_property, assertion, check_response)
      value_to_check = case check_property
                       when 'status' then check_response.status
                       when 'body' then check_response.body
                       when 'code' then check_response.status_code
                       when 'response_time' then check_response.time('response')
                       end
      ::Inspector::Eval.send(assertion.condition, value_to_check, assertion.operand)
    end
  end
end
