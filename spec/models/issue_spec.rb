require 'spec_helper'

describe Issue do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:state) }
  it { should ensure_inclusion_of(:state).in_array([Issue::OPEN, Issue::RESOLVED, Issue::CLOSED, Issue::WONTFIX]) }

  describe "#state_to_s" do
    let(:open) { FactoryGirl.create(:issue, state: Issue::OPEN) }

    it "returns a 'Open' when state is OPEN" do
      expect(open.state_to_s).to eq("Open")
    end

    let(:closed) { FactoryGirl.create(:issue, state: Issue::CLOSED) }

    it "returns a 'Closed' when state is Closed" do
      expect(closed.state_to_s).to eq("Closed")
    end

    let(:resolved) { FactoryGirl.create(:issue, state: Issue::RESOLVED) }

    it "returns a 'Resolved' when state is Resolved" do
      expect(resolved.state_to_s).to eq("Resolved")
    end

    let(:wontfix) { FactoryGirl.create(:issue, state: Issue::WONTFIX) }

    it "returns a 'wontfix' when state is Wontfix" do
      expect(wontfix.state_to_s).to eq("wontfix")
    end
  end
end
