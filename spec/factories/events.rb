FactoryBot.define do
  factory :event do
    start_datetime { Time.now }
    end_datetime { Time.now + 1.hour }
  end
end
