FactoryBot.define do
  factory :room do
    room_name { "サッカー" }
    prefecture_id { 2 }
    host_date  { Faker::Date.backward }
    municipalities { "高崎市" }
    association :user
  end
end
