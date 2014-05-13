class User < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mapping do
    indexes :id, type: "integer"
    indexes :email, boost: 10
    indexes :name
    indexes :username, boost: 10
    indexes :created_at, type: "date"
    indexes :updated_at, type: "date"
  end

  has_many :assigned_issues, class_name: "Issue", foreign_key: "assignee_id"
  has_many :reported_issues, class_name: "Issue", foreign_key: "reporter_id"
  has_many :team_relationships
  has_many :teams, through: :team_relationships

  validates_uniqueness_of :username
  validates_presence_of   :username

  def self.search(params)
    tire.search do |es|
      es.query { string params[:query], default_operator: "AND" } if params[:query].present?
      es.filter :term, username: params[:username] if params[:username]
      es.filter :term, email: params[:username] if params[:username]
      es.filter :term, name: params[:name] if params[:name]
    end

  end
end
