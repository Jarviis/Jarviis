class User < ActiveRecord::Base
  include Searchable::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  index_name "users_#{Rails.env}"

  has_many :assigned_issues, class_name: "Issue", foreign_key: "assignee_id"
  has_many :reported_issues, class_name: "Issue", foreign_key: "reporter_id"
  has_many :team_relationships
  has_many :teams, through: :team_relationships

  validates_uniqueness_of :username
  validates_presence_of   :username
end
