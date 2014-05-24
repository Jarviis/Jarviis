require "spec_helper"

describe Permission do
  describe "as guest" do
    let(:permission) { Permission.new(nil) }

    it "does not allow access" do
      expect(permission.allow?).to eq(false)
    end
  end

  describe "as non-admin" do
    let!(:user) { FactoryGirl.create(:user) }
    let(:permission) { Permission.new(user) }

    it "does not allow access" do
      expect(permission.allow?).to eq(false)
    end
  end

  describe "as admin" do
    let!(:user) { FactoryGirl.create(:user, admin: true) }
    let(:permission) { Permission.new(user) }

    it "allows access" do
      expect(permission.allow?).to eq(true)
    end
  end
end
