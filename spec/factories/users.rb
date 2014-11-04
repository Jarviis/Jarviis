FactoryGirl.define do
  factory :user do
    sequence (:name) { |n| "User #{n}" }
    sequence (:username) { |n| "User#{n}" }
    sequence (:email) { |n| "user#{n}@eavgerinos.net" }
    sequence (:authentication_token) { |n| "9a5f95cec344833b2aa9dd#{n}b69a580f#{n}" }
    password "1234567890"
    password_confirmation "1234567890"
  end
end
