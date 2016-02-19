require "spec_helper"

describe SprintSerializer do
  let(:sprint) { FactoryGirl.create(:sprint) }
  let(:issues) { FactoryGirl.create_list(:issue, 2) }

  before do
    sprint.issues = issues

    sprint.save
  end

  subject { JSON.parse(SprintSerializer.new(sprint).to_json) }

  it "includes id" do
    expect(subject["id"]).to eq(sprint.id)
  end

  it "includes name" do
    expect(subject["name"]).to eq(sprint.name)
  end

  it "includes starttime" do
    expect(subject).to have_key("starttime")
  end

  it "includes endtime" do
    expect(subject).to have_key("endtime")
  end

  it "includes percentage" do
    expect(subject["percentage"]).to eq(sprint.percentage)
  end

  it "includes created_at" do
    expect(subject).to have_key("created_at")
  end

  it "includes updated_at" do
    expect(subject).to have_key("updated_at")
  end

  it "includes team" do
    expect(subject["team"]["id"]).to eq(sprint.team.id)
  end

  it "includes issues" do
    expect(subject["issues"].map { |s| s["id"] }).to match_array(issues.map(&:id))
  end
end
