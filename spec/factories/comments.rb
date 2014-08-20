FactoryGirl.define do
  factory :comment do
    comment "I am a comment"
    commentable_type "Issue"
  end
end
