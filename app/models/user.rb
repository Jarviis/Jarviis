class User < ActiveRecord::Base
  include Searchable::User

  before_save :set_auth_token

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  index_name "users_#{Rails.env}"

  has_many :assigned_issues, class_name: "Issue", foreign_key: "assignee_id"
  has_many :reported_issues, class_name: "Issue", foreign_key: "reporter_id"
  has_many :team_relationships
  has_many :teams, through: :team_relationships

  validates_uniqueness_of :username
  validates_presence_of   :username

  # Sets the aauthentication token to a SecureRandom without updating the
  # record to the database.
  def set_auth_token
    return if self.authentication_token.present?
    self.authentication_token = generate_auth_token
  end

  private

  def generate_auth_token
    loop do
      token = SecureRandom.hex
      break token unless self.class.exists?(authentication_token: token)
    end
  end
end
