require "spec_helper"

describe Api::V1::IssuesController do
  include Devise::TestHelpers

  let(:json_response) { JSON.parse(response.body) }

  before(:each) do
    @user = FactoryGirl.create(:user)

    @request.headers["Authorization"] = token_header(@user.authentication_token)
  end

  describe "GET index" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:issues) { FactoryGirl.create_list(:issue, 2, reporter_id: reporter.id) }

    it "returns all issues" do
      get :index, {}

      expected = JSON.parse(issues.map{ |i| IssueSerializer.new(i) }.to_json)

      expect(json_response).to eq(expected)
    end
  end

  describe "GET search" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:issues) { FactoryGirl.create_list(:issue, 2, reporter_id: reporter.id) }


    context "with empty query" do
      it "returns all Issues" do
        get :search

        expected = JSON.parse(issues.map { |i| IssueSerializer.new(i) }.to_json)

        expect(json_response).to eq(expected)
      end
    end
  end

  describe "POST create" do
    let(:assignee) { FactoryGirl.create(:user) }

    context "with valid params" do

      let(:params) do
        { issue: {
            assignee_id: assignee.id,
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
        issue = Issue.where(state: Issue::OPEN).last
        expected = JSON.parse(IssueSerializer.new(issue).to_json)

        expect(json_response).to eq(expected)
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

  describe "GET comments" do
    let(:reporter) { FactoryGirl.create(:user) }
    let!(:issue) { FactoryGirl.create(:issue, reporter_id: reporter.id) }
    let!(:comments) do
      FactoryGirl.create_list(:comment, 2,
                              user_id: @user.id,
                              commentable_id: issue.id)
    end

    it "reponds with a json with all the comments of the issue" do
      get :comments, id: issue.id

      expect(response.body).to eq(issue.comments.to_json)
    end
  end
end
