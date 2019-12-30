FactoryBot.define do
  factory :message do
    content { "MyString" }
    user { nil }
    room { nil }
  end
end
