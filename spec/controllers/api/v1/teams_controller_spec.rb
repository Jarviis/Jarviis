require "spec_helper"

describe Api::V1::TeamsController do
  include Devise::TestHelpers

  before(:each) do
    @user = FactoryGirl.create(:user)

    @request.headers["Authorization"] = token_header(@user.authentication_token)
  end

  describe "GET index" do
    let!(:teams) { FactoryGirl.create_list(:team, 2) }

    it "fetches all teams" do
      get :index

      expect(assigns(:teams)).to match_array(teams)
    end
  end

  describe "GET show" do
    let!(:team) { FactoryGirl.create(:team) }

    it "fetches the team for the given id" do
      get :show, id: team.id

      expect(assigns(:team)).to eq(team)
    end
  end
end
