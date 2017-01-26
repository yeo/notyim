class CheckResponse
  attr_reader :raw_result
  def initialize(result)
    @raw_result = result
    @hash = JSON.parse(result)
  end

  def body
    @hash['body']
  end

  def time(action)
    @hash['time'][action]
  end

  def response_code
    @hash['response_code']
  end

  def error
    Array.new @hash['error'], @hash['error_message']
  end

  def self.create_from_raw_result(result)
    new result
  end
end
