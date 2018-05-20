FactoryBot.define do
  factory :assertion do
    subject "http.status"
    condition "eq"
    operand 200
  end
end
