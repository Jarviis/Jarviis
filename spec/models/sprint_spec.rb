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

    context "when there are no issues" do
      it "sets percentage to 0" do
        sprint.save

        expect(sprint.percentage).to eq(0.0)
      end
    end
  end

  describe "#update_sprint_percentage!" do
    let(:sprint) { FactoryGirl.create(:sprint) }

    let(:issue1) { FactoryGirl.create(:issue, :open) }
    let(:issue2) { FactoryGirl.create(:issue, :closed) }

    before do
      sprint.issues << issue1
      sprint.issues << issue2
    end

    it "properly sets percentage" do
      expect {
        sprint.update_sprint_percentage!
      }.to change {
        sprint.reload.percentage
      }.from(0.0).to(0.5)
    end
  end
end
