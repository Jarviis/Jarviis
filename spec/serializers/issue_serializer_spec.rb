require "spec_helper"

describe IssueSerializer do
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
    expect(JSON.parse(IssueSerializer.new(issue).to_json)["id"]).
      to eq(123)
  end

  it "includes name" do
    expect(JSON.parse(IssueSerializer.new(issue).to_json)["name"]).
      to eq("Jarviis")
  end

  it "includes description" do
    expect(JSON.parse(IssueSerializer.new(issue).to_json)["description"]).
      to eq("Description")
  end

  it "includes state" do
    expect(JSON.parse(IssueSerializer.new(issue).to_json)["state"]).
      to eq(Issue::OPEN)
  end

  it "includes due_date" do
    expect(JSON.parse(IssueSerializer.new(issue).to_json)).
      to have_key("due_date")
  end

  it "includes parent" do
    serialized_hash = JSON.parse(IssueSerializer.new(issue).to_json)["parent"]
    expect(serialized_hash).to have_key("id")
    expect(serialized_hash).to have_key("name")
    expect(serialized_hash).to have_key("state")
  end

  it "includes childern" do
    expect(JSON.parse(IssueSerializer.new(issue).to_json)["children"]).to eq []
  end

  it "includes reporter" do
    expect(JSON.parse(IssueSerializer.new(issue).to_json)).
      to have_key("reporter")
  end

  it "includes assignee" do
    expect(JSON.parse(IssueSerializer.new(issue).to_json)).
      to have_key("assignee")
  end
end
