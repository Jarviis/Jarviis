require 'spec_helper'

describe Team do
  it { should have_many(:team_relationships) }
  it { should have_many(:users).through(:team_relationships) }

  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }

  describe "before_save hooks" do
    let(:team) { FactoryGirl.build(:team) }

    context "when the slug is lowercased" do
      before do
        team.slug = "dev"
      end

      it "upercases the slug" do
        team.save

        expect(team.reload.slug).to eq("DEV")
      end
    end
  end
end
