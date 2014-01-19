FactoryGirl.define do
  factory :user do
    sequence (:name) { |n| "User #{n}" }
    sequence (:email) { |n| "user#{n}@eavgerinos.net" }
    password "1234567890"
    password_confirmation "1234567890"
  end
end
