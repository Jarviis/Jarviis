require "spec_helper"

describe Api::V1::IssuesController do

  let(:json_response) { JSON.parse(response.body) }

  describe "#index" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:issues) { FactoryGirl.create_list(:issue, 2, reporter_id: reporter.id) }

    it "returns all issues" do
      get :index

      expect(response.body).to eq(Issue.search({}).to_json)
    end
  end

  describe "POST create" do
    let(:assignee) { FactoryGirl.create(:user) }
    let(:reporter) { FactoryGirl.create(:user) }

    context "with valid params" do

      let(:params) do
        { issue: {
            assignee_id: assignee.id,
            reporter_id: reporter.id,
            name: "Make Jarviis awesome",
            description: "I am a fancy description ftw"
          }
        }
      end

      it "creates an open issue" do
        expect {
          post :create, params
        }.to change { Issue.where(state: Issue::OPEN).count }.by(1)
      end

      it "returns status created" do
        post :create, params

        expect(json_response["status"]).to eq("created")
      end

      it "does not return any errors" do
        post :create, params

        expect(json_response["errors"]).to be_nil
      end
    end

    context "with invalid params" do
      let(:params) do
        { issue: {
            assignee_id: assignee.id,
            reporter_id: reporter.id,
            name: nil,
            description: "I am a fancy description ftw"
          }
        }
      end

      it "returns the issue's errors" do
        post :create, params

        expect(json_response["errors"]).to be
      end

      it "returns status unprocessable_entity" do
        post :create, params

        expect(json_response["status"]).to eq("unprocessable_entity")
      end
    end
  end

  describe "PUT update" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:issue) { FactoryGirl.create(:issue, name: "OLD", reporter_id: reporter.id) }

    context "with valid changes" do
      let(:params) do
        { id: issue.id, issue: { name: "NEW" } }
      end

      it "updates the changed attributes" do
        put :update, params

        expect(issue.reload.name).to eq("NEW")
      end
    end
  end

  describe "DELETE destroy" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:issue) { FactoryGirl.create(:issue, name: "OLD", reporter_id: reporter.id) }

    it "destroys the issue" do
      expect {
        delete :destroy, id: issue.id
      }.to change { Issue.count }.by(-1)
    end

    it "returns status destroyed" do
      delete :destroy, id: issue.id

      expect(json_response["status"]).to eq("destroyed")
    end
  end

  describe "POST resolve" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:issue) { FactoryGirl.create(:issue, name: "OLD", reporter_id: reporter.id) }

    it "changes the state of issue to RESOLVED" do
      expect {
        post :resolve, id: issue.id
      }.to change {
        issue.reload.state
      }.from(Issue::OPEN).to(Issue::RESOLVED)
    end
  end
end
