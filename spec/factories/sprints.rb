FactoryGirl.define do
  factory :sprint do
    starttime Time.now - 2.days
    endtime Time.now + 10.days
    sequence (:name) { |n| "Name #{n}" }
  end
end
