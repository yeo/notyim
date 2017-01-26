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
    check_response = CheckResponse.create_from_raw_result raw_check_response

    # TODO check for down/non 2xx,3xx event if no assertion was created
    check.assertions.each do |assertion|
      inspector = Inspector.new assertion
      if inspector.check(check_response)
        IncidentService.create_for_assertion(assertion, check_response)
      end
    end
  end
end
