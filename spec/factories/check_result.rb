FactoryBot.define do
  factory :check_response do
    raw_result({
      check_id: 123,
      type: 'http',
      time: [],
      body: 'ok',
      error: false,
      error_message: nil,
      http: {},
      from_ip: '1.2.3.4',
      from_region: 'us',
    })
  end
end
