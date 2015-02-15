FactoryGirl.define do
  factory :attachment do
    filename File.open(Rails.root.join("spec/fixtures/Lenna.png"))
  end
end
