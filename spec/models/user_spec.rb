require 'spec_helper'

describe User do
  it { should respond_to(:name) }

  describe "issues associations" do
    let(:assignee) { FactoryGirl.create(:user) }
    let(:reporter) { FactoryGirl.create(:user) }

    let!(:issues) do
      FactoryGirl.create_list(:issue, 2,
                              reporter_id: reporter.id,
                              assignee_id: assignee.id)
    end

    it "returns the assigned issues to the assignee" do
      expect(assignee.assigned_issues).to eq(issues)
    end

    it "returns the reported issues to the reporter" do
      expect(reporter.reported_issues).to eq(issues)
    end

    context "when assignee has no reported issues" do
      it "does not return reported issues to the assignee" do
        expect(assignee.reported_issues).to eq([])
      end
    end

    context "when the reported has no assigned issues" do
      it "does not rethrn assigned issues to the reporter" do
        expect(reporter.assigned_issues).to eq([])
      end
    end
  end
end
