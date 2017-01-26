class CheckToCreateIncidentWorker
  include Sidekiq::Worker

  # @param sting check id
  # @param Hash result
  #         - total_time
  #         - body
  #         - total_size
  #         - response_code
  def perform(check_id, result)
    check = Check.find(check_id)
    # TODO check for down/non 2xx,3xx event if no assertion was created
    check.assertions.each do |assertion|
      inspector = InspectorService.new assertion
      if inspector.check(result)
        IncidentService.create_for_assertion(assertion)
      end
    end
  end
end
