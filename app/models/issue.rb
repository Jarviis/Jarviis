class Issue < ActiveRecord::Base
  OPEN = 0
  RESOLVED = 1
  CLOSED = 2
  WONTFIX = 3

  HUMANIZED_STATE = {
    OPEN => "Open",
    RESOLVED => "Resolved",
    CLOSED => "Closed",
    WONTFIX => "wontfix"
  }

  belongs_to :reporter, class_name: "User", foreign_key: "reporter_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"

  validates :state, inclusion: { in: [OPEN, RESOLVED, CLOSED, WONTFIX] }
  validates_presence_of :name, :state, :reporter

  # @return [String] A humananized representation of the state of the issue.
  def state_to_s
    HUMANIZED_STATE[self.state]
  end
  # @return [String] The name of the assignee, Nobody if there no assignee
  def assignee_name
    assignee.present? ? assignee.name : "Nobody"
  end

  # @return [String] The name of the reporter
  def reporter_name
    reporter.name
  end
end
