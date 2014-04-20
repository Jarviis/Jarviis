require 'spec_helper'

describe Issue do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:state) }
  it { should ensure_inclusion_of(:state).in_array([Issue::OPEN, Issue::RESOLVED, Issue::CLOSED, Issue::WONTFIX]) }
  it { should validate_presence_of(:reporter) }

  let(:reporter) { FactoryGirl.create(:user) }
  let(:assignee) { FactoryGirl.create(:user) }

  describe "#state_to_s" do
    let(:open) do
      FactoryGirl.create(:issue, :open,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "returns a 'Open' when state is OPEN" do
      expect(open.state_to_s).to eq("Open")
    end

    let(:closed) do
      FactoryGirl.create(:issue, :closed,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "returns a 'Closed' when state is Closed" do
      expect(closed.state_to_s).to eq("Closed")
    end

    let(:resolved) do
      FactoryGirl.create(:issue, :resolved,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "returns a 'Resolved' when state is Resolved" do
      expect(resolved.state_to_s).to eq("Resolved")
    end

    let(:wontfix) do
      FactoryGirl.create(:issue, :wontfix,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "returns a 'wontfix' when state is Wontfix" do
      expect(wontfix.state_to_s).to eq("wontfix")
    end
  end

  describe "#assignee_name" do
    let(:issue) do
      FactoryGirl.create(:issue,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "returns the asignee name" do
      expect(issue.assignee_name).to eq(assignee.name)
    end

    context "when the issue has no assignee" do
      let(:issue_without_assignee) do
        FactoryGirl.create(:issue, reporter_id: reporter.id)
      end

      it "returns 'Nobody'" do
        expect(issue_without_assignee.assignee_name).to eq("Nobody")
      end
    end
  end

  describe "#assignee_username" do
    let(:issue) do
      FactoryGirl.create(:issue,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "returns the asignee name" do
      expect(issue.assignee_username).to eq(assignee.username)
    end

    context "when the issue has no assignee" do
      let(:issue_without_assignee) do
        FactoryGirl.create(:issue, reporter_id: reporter.id)
      end

      it "returns 'Nobody'" do
        expect(issue_without_assignee.assignee_username).to eq("Nobody")
      end
    end
  end

  describe "#reporter_name" do
    let(:issue) do
      FactoryGirl.create(:issue,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "returns the reporter name" do
      expect(issue.reporter_name).to eq(reporter.name)
    end
  end

  describe "#reporter_name" do
    let(:issue) do
      FactoryGirl.create(:issue,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "returns the reporter name" do
      expect(issue.reporter_username).to eq(reporter.username)
    end
  end

  describe "#resolve!" do
    context "when the issue is open" do
      let(:issue) do
        FactoryGirl.create(:issue, :open,
                           assignee_id: assignee.id,
                           reporter_id: reporter.id)
      end

      it "returns true" do
        expect(issue.resolve!).to eq(true)
      end

      it "changes the state to resolved" do
        expect {
          issue.resolve!
        }.to change { issue.reload.state }.to(Issue::RESOLVED)
      end
    end

    context "when the issue is not open" do
      let(:issue) do
        FactoryGirl.create(:issue, :closed,
                           assignee_id: assignee.id,
                           reporter_id: reporter.id)
      end

      it "returns false" do
        expect(issue.resolve!).to eq(false)
      end

      it "does not change the state" do
        expect {
          issue.resolve!
        }.not_to change { issue.reload.state }
      end
    end
  end

  describe "#close!" do
    context "when the issue is open" do
      let(:issue) do
        FactoryGirl.create(:issue, :open,
                           assignee_id: assignee.id,
                           reporter_id: reporter.id)
      end

      it "returns true" do
        expect(issue.close!).to eq(true)
      end

      it "changes the state to resolved" do
        expect {
          issue.close!
        }.to change { issue.reload.state }.to(Issue::CLOSED)
      end
    end

    context "when the issue is not open" do
      let(:issue) do
        FactoryGirl.create(:issue, :closed,
                           assignee_id: assignee.id,
                           reporter_id: reporter.id)
      end

      it "returns false" do
        expect(issue.close!).to eq(false)
      end

      it "does not change the state" do
        expect {
          issue.close!
        }.not_to change { issue.reload.state }
      end
    end
  end

  describe "#wontfix!" do
    let(:issue) do
      FactoryGirl.create(:issue, :closed,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "changes the issue status to wontfix" do
      expect {
        issue.wontfix!
      }.to change { issue.reload.state }.to(Issue::WONTFIX)
    end
  end

  describe "#open!" do
    let(:issue) do
      FactoryGirl.create(:issue, :closed,
                         assignee_id: assignee.id,
                         reporter_id: reporter.id)
    end

    it "changes the issue status to open" do
      expect {
        issue.open!
      }.to change { issue.reload.state }.to(Issue::OPEN)
    end

    it "returns true" do
      expect(issue.open!).to eq(true)
    end

    describe "when status is already open" do
      let(:issue) do
        FactoryGirl.create(:issue,
                           assignee_id: assignee.id,
                           reporter_id: reporter.id)
      end

      it "returns false" do
        expect(issue.open!).to eq(false)
      end
    end
  end
end
