FactoryBot.define do
  factory :user do
    name {"Example User"}
    sequence(:email) {|n| "user#{n}@example.com"}
    password {"foobar"}
    password_confirmation {"foobar"}
    admin {true}
    activated {true}
    activated_at {Time.zone.now}
  end
end
