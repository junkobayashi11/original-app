FactoryBot.define do
  factory :comment do
    text  {"元気"}
    association :user
    association :room
  end
end
