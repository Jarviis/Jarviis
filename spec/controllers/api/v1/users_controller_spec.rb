require "spec_helper"

describe Api::V1::UsersController do

  let(:json_response) { JSON.parse(response.body) }

  describe "#index" do
    let(:users) { FactoryGirl.create_list(:user, 2) }

    it "returns all issues" do
      get :index

      expect(response.body).to eq(User.search({}).to_json)
    end
  end
end
