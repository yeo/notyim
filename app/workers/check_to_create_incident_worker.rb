# frozen_string_literal: true

class CheckToCreateIncidentWorker
  include Sidekiq::Worker

  # @param sting check id
  # @param Hash result
  #         - total_time
  #         - body
  #         - total_size
  #         - response_code
  def perform(check_id, raw_check_response)
    check = Check.find(check_id)
    logger.info raw_check_response

    # TODO: CheckLog should be in a circular buffer
    CheckLog.create!(response: JSON.parse(raw_check_response), check: check)

    check_response = CheckResponse.create_from_raw_result raw_check_response

    # TODO: check for down/non 2xx,3xx event if no assertion was created
    check.assertions.each do |assertion|
      inspector = CheckInspector.new assertion
      case inspector.match?(check_response)
      when true
        IncidentService.create_for_assertion(assertion, check_response)
      when false
        IncidentService.close_for_assertion(assertion, check_response)
      end
    rescue StandardError => e
      Raven.capture_exception(e, extra: { check: check_id })
    end
  end
end
