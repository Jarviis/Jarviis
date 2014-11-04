require "spec_helper"

describe Api::V1::UsersController do
  include Devise::TestHelpers

  before(:each) do
    @user = FactoryGirl.create(:user)

    @request.headers["Authorization"] = token_header(@user.authentication_token)
  end

  let(:json_response) { JSON.parse(response.body) }

  describe "GET index" do
    let!(:users) { FactoryGirl.create_list(:user, 2) }

    it "returns all issues" do
      get :index
      users = User.all
      expected = JSON.parse(users.map { |u| UserSerializer.new(u) }.to_json)

      expect(json_response).to eq(expected)
    end
  end
end
