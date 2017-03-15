class CheckResponse
  include Mongoid::Document

  # raw result is a hash include these fields:
  #   - check_id: string reference to the check
  #   - type: string either http|tcp currently
  #   - time:
  #       - action: value in seconds
  #       ...
  #   - body: string body of response
  #   - error: true/false
  #   - error_message: string
  #   - http:
  #       - http field
  #   - tcp:
  #       - tcp field
  #   - attbs:
  #       - name: value
  #   - from_ip:
  #   - from_region:
  field :raw_result, type: Hash

  # The reason we use two associated here is to improve
  # how we fetch the incident since we don't have join
  belongs_to :assertion
  belongs_to :incident

  # Response body
  def body
    raw_result['body']
  end

  # Timing
  def total_response_time
    time('Total')
  end

  def time(action)
    raw_result['time'][action]
  end

  def code
    raw_result['http']['code'] if raw_result['http']
  end

  # http status code
  def status_code
    raw_result['status_code']
  end

  def status
    if error.nil? || !error
      'up'.freeze
    else
      'down'.freeze
    end
  end

  def error
    raw_result['error']
  end

  def error_message
    raw_result['error_message']
  end

  def from_ip
    raw_result['from_ip']
  end

  def self.create_from_raw_result(result)
    raw_result = JSON.parse(result)
    new(raw_result: raw_result)
  end
end
