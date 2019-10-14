FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "Example user#{n}"}
    sequence(:email) {|n| "user#{n}@example.com"}
    password {"foobar"}
    password_confirmation {"foobar"}
    admin {true}
    activated {true}
    activated_at {Time.zone.now}
  end

  factory :micropost do
    content { "Lorem ipsum" }
    user
  end
end
