require "spec_helper"

describe ChildrenSerializer do
  let!(:reporter) { FactoryGirl.create(:user) }
  let!(:parent_issue) { FactoryGirl.create(:issue, reporter_id: reporter.id) }
  let!(:issue) do
    FactoryGirl.create(:issue,
                       name: "Jarviis",
                       id: 123,
                       description: "Description",
                       state: Issue::OPEN,
                       due_date: nil,
                       parent_id: parent_issue.id,
                       reporter_id: reporter.id,
                       assignee_id: nil)
  end

  it "includes id" do
    expect(JSON.parse(ChildrenSerializer.new(issue).to_json)["id"]).
      to eq(123)
  end

  it "includes name" do
    expect(JSON.parse(ChildrenSerializer.new(issue).to_json)["name"]).
      to eq("Jarviis")
  end

  it "includes state" do
    expect(JSON.parse(ChildrenSerializer.new(issue).to_json)["state"]).
      to eq(Issue::OPEN)
  end

  it "includes description" do
    expect(JSON.parse(ChildrenSerializer.new(issue).to_json)).
      not_to have_key("description")
  end

  it "includes due_date" do
    expect(JSON.parse(ChildrenSerializer.new(issue).to_json)).
      not_to have_key("due_date")
  end
end
