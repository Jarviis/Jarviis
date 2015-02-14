FactoryGirl.define do
  factory :team do
    sequence (:name) { |n| "Team #{n}" }
    sequence (:slug) { |n| "DEV#{n}" }
  end
end
