FactoryGirl.define do
  factory :issue do
    sequence (:name) { |n| "Name #{n}" }
    state Issue::OPEN
    description "I am a fancy description"
  end
end
