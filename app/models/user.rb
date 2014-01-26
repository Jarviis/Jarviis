class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :assigned_issues, class_name: "Issue", foreign_key: "assignee_id"
  has_many :reported_issues, class_name: "Issue", foreign_key: "reporter_id"
end
