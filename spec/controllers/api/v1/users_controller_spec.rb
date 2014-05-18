require "spec_helper"

describe Api::V1::UsersController do
  include Devise::TestHelpers

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  let(:json_response) { JSON.parse(response.body) }

  describe "GET index" do
    it "returns all issues" do
      get :index
      users = User.all
      expected = JSON.parse(users.map { |u| UserSerializer.new(u) }.to_json)

      expect(json_response).to eq(expected)
    end
  end
end
