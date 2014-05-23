require "spec_helper"

describe Admin::UsersController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    request.env["HTTP_REFERER"] = "http://google.com"
  end

  describe "PUT/PATCH update" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:team) { FactoryGirl.create(:team) }

    let(:params) do
      {
        id: user.id,
        user: {
          name: 'Jarviis',
          username: 'jarviis',
          team_ids: [team.id],
        }
      }
    end

    it "updates name" do
      expect {
        patch :update, params
      }.to change {
        user.reload.name
      }.to(params[:user][:name])
    end

    it "updates username" do
      expect {
        patch :update, params
      }.to change {
        user.reload.username
      }.to(params[:user][:username])
    end

    it "updates teams" do
      user.teams = []
      user.save
      expect {
        patch :update, params
      }.to change {
        user.reload.teams.map(&:id)
      }.to([team.id])
    end

    context "when updating password" do
      context "without password_confirmation" do
        let(:invalid) do
          params[:user][:password] = "1234567890"

          params
        end

        it "does not update the password" do
          expect {
            patch :update, invalid
          }.not_to change {
            user.reload.encrypted_password
          }
        end
      end

      context "with password confirmation" do
        let(:valid) do
          params[:user][:password] = "1234567890123"
          params[:user][:password_confirmation] =
            "1234567890123"

          params
        end

        it "updates the password" do
          expect {
            patch :update, valid
          }.to change {
            user.reload.encrypted_password
          }
        end
      end
    end

  end

  describe "DELETE destroy" do
    let!(:user) { FactoryGirl.create(:user) }

    it "destroys the given user" do
      expect {
        delete :destroy, id: user.id
      }.to change { User.count }.by(-1)
    end

    it "creates a new forensic record" do
      expect {
        delete :destroy, id: user.id
      }.to change { Forensic.count }.by(+1)
    end
  end
end
