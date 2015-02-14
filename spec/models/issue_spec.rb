require 'spec_helper'

describe Issue do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:team_id) }
  it { should ensure_inclusion_of(:state).in_array([Issue::OPEN, Issue::RESOLVED, Issue::CLOSED, Issue::WONTFIX]) }
  it { should validate_presence_of(:reporter) }

  let(:reporter) { FactoryGirl.create(:user) }
  let(:assignee) { FactoryGirl.create(:user) }

  describe "after_save callbacks" do
    context "when the record is new" do
      let!(:team) do
        FactoryGirl.create(:team, slug: "DEV")
      end
      let!(:issue) { FactoryGirl.create(:issue, team: team) }

      before { issue.run_callbacks(:commit) }

      it "sets prepends the slug and the id" do
        expect(issue.name).to match(/DEV-#{issue.id}/)
      end
    end

    context "when it is an update" do
      let!(:team) do
        FactoryGirl.create(:team, slug: "DEV")
      end
      let!(:issue) { FactoryGirl.create(:issue, team: team) }
      let(:another_team) { FactoryGirl.create(:team, slug: "OPS") }

      before do
        issue.team_id = another_team.id
        issue.save
        issue.run_callbacks(:commit)
      end

      it "re-sets the name with the correct slug prepended" do
        expect(issue.name).to match(/OPS-#{issue.id}/)
      end
    end
  end

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

  describe "#has_descendants?" do
    let!(:root) do
      FactoryGirl.create(:issue, reporter_id: reporter.id)
    end

    let!(:child) do
      FactoryGirl.create(:issue,
                         reporter_id: reporter.id,
                         parent_id: root.id)
    end

    context "when it has descendants" do
      it "returns true" do
        expect(root.has_descendants?).to eq(true)
      end
    end

    context "when it has none descendant" do
      it "returns false" do
        expect(child.has_descendants?).to eq(false)
      end
    end
  end

  describe "#has_parent?" do
    let!(:root) do
      FactoryGirl.create(:issue, reporter_id: reporter.id)
    end

    let!(:child) do
      FactoryGirl.create(:issue,
                         reporter_id: reporter.id,
                         parent_id: root.id)
    end

    context "when it has parent_id set" do
      it "returns true" do
        expect(child.has_parent?).to eq(true)
      end
    end

    context "when it has not parent_id set" do
      it "returns false" do
        expect(root.has_parent?).to eq(false)
      end
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
