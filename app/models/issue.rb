class Issue < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

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

  PER_PAGE = 15

  mapping do
    indexes :id, type: "integer"
    indexes :assignee_id, type: "integer"
    indexes :assignee_name, boost: 10
    indexes :assignee_username, boost: 20
    indexes :reporter_id, type: "integer"
    indexes :reporter_name, boost: 10
    indexes :reporter_username, boost: 20
    indexes :name
    indexes :username
    indexes :state, type: "integer"
    indexes :description
    indexes :created_at, type: "date"
    indexes :updated_at, type: "date"
    indexes :due_date, type: "date"
  end

  belongs_to :reporter, class_name: "User", foreign_key: "reporter_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"

  validates :state, inclusion: { in: [OPEN, RESOLVED, CLOSED, WONTFIX] }
  validates_presence_of :name, :state, :reporter

  # @return [String] A humananized representation of the state of the issue.
  def state_to_s
    HUMANIZED_STATE[self.state]
  end

  # Search criteria
  def self.search(params)
    tire.search(page: params[:page] || 1, per_page: PER_PAGE) do |es|
      es.query { string params[:query], default_operator: "AND" } if params[:query].present?
      es.filter :term, assignee_id: params[:assignee_id] if params[:assignee_id]
      es.filter :term, reporter_id: params[:reporter_id] if params[:reporter_id]
      es.filter :term, assignee_username: params[:assignee_username] if params[:assignee_username]
      es.filter :term, reporter_username: params[:reporter_username] if params[:reporter_username]
      es.sort { by :created_at, "desc" } if params[:query].blank?
    end
  end

  def to_indexed_json
    to_json(methods: [:assignee_name, :assignee_username, :reporter_username, :reporter_name])
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
end
