FactoryGirl.define do
  factory :issue do
    sequence (:name) { |n| "Name #{n}" }
    state Issue::OPEN
    description "I am a fancy description"
    association :team, factory: :team
    association :reporter, factory: :user
  end

  trait :open do
    state Issue::OPEN
  end

  trait :closed do
    state Issue::CLOSED
  end

  trait :resolved do
    state Issue::RESOLVED
  end

  trait :wontfix do
    state Issue::WONTFIX
  end
end
