class Issue < ActiveRecord::Base
  include Searchable::Issue

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

  acts_as_commentable

  index_name "issues_#{Rails.env}"

  paginates_per 15

  belongs_to :reporter, class_name: "User", foreign_key: "reporter_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"

  validates :state, inclusion: { in: [OPEN, RESOLVED, CLOSED, WONTFIX] }
  validates_presence_of :name, :state, :reporter

  # @return [String] A humananized representation of the state of the issue.
  def state_to_s
    HUMANIZED_STATE[self.state]
  end

  def as_indexed_json(options={})
    as_json(methods: [:assignee_name, :assignee_username, :reporter_username, :reporter_name])
  end

  # @return [String] The name of the assignee, Nobody if there is no assignee
  def assignee_name
    assignee.present? ? assignee.name : "Nobody"
  end

  # @return [String] The username of the assignee, Nobody if there is no assignee
  def assignee_username
    assignee.present? ? assignee.username : "Nobody"
  end

  # @return [String] The name of the reporter
  def reporter_name
    reporter.name
  end

  # @return [String] The username of the reporter
  def reporter_username
    reporter.username
  end

  # @return [Boolean] True if the state transition was valid
  def resolve!
    return false if self.state != Issue::OPEN

    self.state = Issue::RESOLVED
    self.save
  end

  # @return [Boolean] True if the state transition was valid
  def close!
    return false if self.state != Issue::OPEN

    self.state = Issue::CLOSED
    self.save
  end

  def wontfix!
    self.state = Issue::WONTFIX

    self.save
  end

  def open!
    return false if self.state == Issue::OPEN

    self.state = Issue::OPEN
    self.save
  end
end
