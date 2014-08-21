require "spec_helper"

describe Api::V1::CommentsController do
  include Devise::TestHelpers

  let(:json_response) { JSON.parse(response.body) }

  let(:reporter) { FactoryGirl.create(:user) }
  let!(:issue) { FactoryGirl.create(:issue, reporter: reporter) }

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "POST create" do
    context "when the params are valid" do
      let(:params) do
        { comment: {
            comment: "This is a comment" },
          issue_id: issue.id
        }
      end

      it "creates a comment" do
        expect {
          post :create, params
        }.to change { Comment.count }.by(1)
      end

      it "assigns the current user correctly" do
        expect {
          post :create, params
        }.to change { Comment.where(user_id: @user.id).count }.by(1)
      end

      it "responds with a json with the comment" do
        post :create, params

        expect(response.body).to eq(Comment.last.to_json)
      end
    end

    context "when the params are invalid" do
      let(:params) do
        { comment: {
            comment: nil },
          issue_id: issue.id
        }
      end

      it "does not save the comment" do
        expect {
          post :create, params
        }.not_to change { Comment.count }
      end

      it "responds with a json with errors" do
        post :create, params

        expect(json_response).to have_key("errors")
      end
    end
  end

  describe "DELETE destroy" do
    context "when the current user owns the comment" do
      let!(:comment) do
        FactoryGirl.create(:comment, commentable_id: issue.id, user_id: @user.id)
      end

      it "destroys the comment" do
        expect {
          delete :destroy, id: comment.id
        }.to change { Comment.count }.by(-1)
      end

      it "responds with a json with status destroyed" do
        delete :destroy, id: comment.id

        expect(json_response["status"]).to eq("destroyed")
      end
    end

    context "when the current user does not own the comment" do
      let!(:comment) do
        FactoryGirl.create(:comment, commentable_id: issue.id, user_id: reporter.id)
      end

      it "does not destroy the comment" do
        expect {
          delete :destroy, id: comment.id
        }.not_to change { Comment.count }
      end

      it "responds with status uanauthorized" do
        delete :destroy, id: comment.id

        expect(response.status).to eq(401)
      end
    end
  end
end
