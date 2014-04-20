require "spec_helper"

describe Api::V1::IssuesController do
  include Devise::TestHelpers

  let(:json_response) { JSON.parse(response.body) }

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

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

    it "calls resolve! on issue" do
      Issue.any_instance.should_receive(:resolve!)

      post :resolve, id: issue.id
    end

    it "returns status updated" do
      post :resolve, id: issue.id

      expect(json_response["status"]).to eq("resolved")
    end

    context "when the state transition is invalid" do
      let!(:closed_issue) do
        FactoryGirl.create(:issue,
                           state: Issue::CLOSED,
                           name: "OLD",
                           reporter_id: reporter.id)
      end

      it "returns errors" do
        post :resolve, id: closed_issue.id

        expect(json_response["errors"]).to be
      end

      it "returns status unprocessable_entity" do
        post :resolve, id: closed_issue.id

        expect(json_response["status"]).to eq("unprocessable_entity")
      end
    end
  end

  describe "POST close" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:issue) { FactoryGirl.create(:issue, name: "OLD", reporter_id: reporter.id) }

    it "calls close! on issue" do
      Issue.any_instance.should_receive(:close!)

      post :close, id: issue.id
    end

    it "returns status closed" do
      post :close, id: issue.id

      expect(json_response["status"]).to eq("closed")
    end

    context "when the state transition is invalid" do
      let!(:closed_issue) do
        FactoryGirl.create(:issue,
                           state: Issue::CLOSED,
                           name: "OLD",
                           reporter_id: reporter.id)
      end

      it "returns errors" do
        post :close, id: closed_issue.id

        expect(json_response["errors"]).to be
      end

      it "returns status unprocessable_entity" do
        post :close, id: closed_issue.id

        expect(json_response["status"]).to eq("unprocessable_entity")
      end
    end
  end

  describe "POST wontfix" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:issue) { FactoryGirl.create(:issue, name: "OLD", reporter_id: reporter.id) }

    it "calls wontfix! on issue" do
      Issue.any_instance.should_receive(:wontfix!)

      post :wontfix, id: issue.id
    end

    it "returns status closed" do
      post :wontfix, id: issue.id

      expect(json_response["status"]).to eq("wontfix")
    end

    context "with any state" do
      it "calls wontfix! on issue" do
        Issue.any_instance.should_receive(:wontfix!)

        post :wontfix, id: issue.id
      end

      it "returns status wontfix" do
        post :wontfix, id: issue.id

        expect(json_response["status"]).to eq("wontfix")
      end
    end
  end

  describe "open" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:closed_issue) do
      FactoryGirl.create(:issue,
                         state: Issue::CLOSED,
                         name: "OLD",
                         reporter_id: reporter.id)
    end

    it "calls open! on issue" do
      Issue.any_instance.should_receive(:open!)

      post :open, id: closed_issue.id
    end

    it "returns status open" do
      post :open, id: closed_issue.id

      expect(json_response["status"]).to eq("open")
    end

    context "when is already open" do
      let!(:issue) do
        FactoryGirl.create(:issue,
                           name: "OLD",
                           reporter_id: reporter.id)
      end

      it "returns errors" do
        post :open, id: issue.id

        expect(json_response["status"]).to be
      end
    end
  end
end
