require "spec_helper"

describe Api::V1::AttachmentsController do
  include Devise::TestHelpers

  let(:json_response) { JSON.parse(response.body) }

  before(:each) do
    @user = FactoryGirl.create(:user)

    @request.headers["Authorization"] = token_header(@user.authentication_token)
  end

  describe "POST create" do
    let!(:issue) { FactoryGirl.create(:issue, reporter: @user) }

    context "with valid params" do

      let(:params) do
        { attachment: {
          filename: fixture_file_upload("Lenna.png", "image/png")
          },
          id: issue.id
        }
      end

      it "creates an attachment for the issue" do
        expect {
          post :create, params
        }.to change { issue.reload.attachments.count }.by(1)
      end

      it "does not return any errors" do
        post :create, params

        expect(json_response["errors"]).to be_nil
      end
    end

    context "with invalid params" do
      let(:params) do
        { attachment: {
            filename: nil
          },
          id: issue.id
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

  describe "DELETE destroy" do
    let(:reporter) { FactoryGirl.create(:user) }
    let(:issue) { FactoryGirl.create(:issue, name: "OLD", reporter_id: reporter.id) }
    let!(:attachment) do
      FactoryGirl.create(
        :attachment,
        filename: File.open(Rails.root.join("spec/fixtures/Lenna.png"))
      )
    end

    it "destroys the attachment" do
      expect {
        delete :destroy, id: attachment.id
      }.to change {
        Attachment.exists?(attachment.id)
      }.from(true).to(false)
    end

    it "returns status destroyed" do
      delete :destroy, id: attachment.id

      expect(json_response["status"]).to eq("destroyed")
    end
  end
end
