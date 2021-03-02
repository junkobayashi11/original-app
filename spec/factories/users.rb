FactoryBot.define do
  factory :user do
    name          {Faker::Name.name}
    phone_number  {Faker::PhoneNumber.cell_phone}
    profile       { "元気" }
    prefecture_id { 2 }
    email         { Faker::Internet.email}
    password      { "7777jjjj" }
    password_confirmation { password }
  end
end
