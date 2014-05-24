require 'spec_helper'

describe Forensic do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:action) }
  it { should ensure_inclusion_of(:action).in_array(Forensic::ACTIONS.values) }

  it "squishes the description before saving" do
    forensic = Forensic.new
    forensic.description = "         A        car       "
    forensic.action = Forensic::ACTIONS[:destroy_user]
    forensic.user_id = 1
    forensic.save

    expect(forensic.reload.description).to eq("A car")
  end
end
