require "spec_helper"

describe Admin::UsersController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    request.env["HTTP_REFERER"] = "http://google.com"
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
