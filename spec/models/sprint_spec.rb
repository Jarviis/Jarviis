require 'spec_helper'

describe Sprint do
  it { should belong_to(:team) }
  it { should validate_presence_of(:name) }

  describe "after_create callbacks" do
    let(:sprint) { FactoryGirl.build(:sprint) }

    it "calls update_sprint_percentage" do
      expect(sprint).to receive(:update_sprint_percentage!)

      sprint.save
      sprint.run_callbacks(:commit)
    end
  end
end
