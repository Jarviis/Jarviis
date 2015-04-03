require "spec_helper"

describe Api::V1::SprintsController do
  include Devise::TestHelpers

  let(:json_response) { JSON.parse(response.body) }


  before(:each) do
    @user = FactoryGirl.create(:user)

    @request.headers["Authorization"] = token_header(@user.authentication_token)
  end

  describe "GET show"do
    let(:issues) { FactoryGirl.create_list(:issue, 3) }

    let(:sprint) { FactoryGirl.create(:sprint) }

    before do
      sprint.issues = issues
      sprint.save
    end

    it "returns a sprint serialized along with its issues" do
      get :show, id: sprint.id

      expect(json_response["name"]).to eq(sprint.name)
      expect(json_response["id"]).to eq(sprint.id)
      expect(json_response["issues"].map { |i| i["id"] }.map(&:to_i)).to match_array(issues.map(&:id))
    end
  end

  describe "POST create" do
    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    let!(:team) { FactoryGirl.create(:team) }
    let!(:issue) { FactoryGirl.create(:issue, reporter: @user) }

    context "with valid params" do
      let(:params) do
        { sprint: { name: "First Sprint", starttime: Time.now, endtime: Time.now + 1.month } }
      end

      it "creates a sprint" do
        expect {
          post :create, params
        }.to change {
          Sprint.count
        }.by(1)
      end

      it "does not return any errors" do
        post :create, params

        expect(json_response["errors"]).to be_nil
        expect(response.status).to eq(201)
      end

      it "returns the attributes of the sprint" do
        post :create, params

        params[:sprint].keys.each do |key|
          expect(json_response[key]).to eq(params[key])
        end
      end

    end

    context "with invalid params" do
      let(:params) do
        { sprint: { name: nil, starttime: Time.now, endtime: Time.now + 1.month } }
      end

      it "does not create a sprint" do
        expect {
          post :create, params
        }.not_to change {
          Sprint.count
        }
      end

      it "return a hash with errors" do
        post :create, params

        expect(json_response["errors"]).to be
      end
    end
  end

  describe "PUT/PATCH update" do
    let(:sprint) { FactoryGirl.create(:sprint) }
    let(:issues) { FactoryGirl.create_list(:issue, 2) }


    before do
      sprint.issues = issues

      sprint.save
    end

    context "with valid params" do
      let(:params) { { id: sprint.id, sprint: { name: "kokolala" } } }

      it "correctly sets the sprint" do
        put :update, params

        expect(assigns(:sprint).id).to eq(sprint.id)
      end

      it "updates the passed params" do
        expect {
          put :update, params
        }.to change {
          sprint.reload.name
        }.to("kokolala")
      end

      it "is 200" do
        put :update, params

        expect(response.status).to eq(200)
      end

      it "returs the sprint object serialized" do
        put :update, params

        expect(json_response["id"]).to eq(sprint.id)
      end
    end

    context "with invalid params" do
      let(:params) { { id: sprint.id, sprint: { name: nil } } }

      it "does not update the sprint" do
        expect {
          put :update, params
        }.not_to change {
          sprint.reload
        }
      end

      it "returns errors in the response" do
        put :update, params

        expect(json_response["errors"]).to be
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE destroy" do
    let!(:sprint) { FactoryGirl.create(:sprint) }

    it "destroys the sprint" do
      expect {
        delete :destroy, id: sprint.id
      }.to change {
        Sprint.where(id: sprint.id).any?
      }.from(true).to(false)
    end

    it "responds with 200" do
      delete :destroy, id: sprint.id

      expect(response.status).to eq(200)
    end

    it "responds with the serialized sprint object" do
      sprint_id = sprint.id
      delete :destroy, id: sprint.id

      expect(json_response["id"]).to eq(sprint_id)
    end
  end
end
