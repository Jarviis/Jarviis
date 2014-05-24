# Forensic stores information about aggressive admin actions.
# Who admin did what and when.
class Forensic < ActiveRecord::Base
  before_save :sanitize_description

  ACTIONS = {
    destroy_user: 1,
    destroy_team: 2,
    destroy_issue: 3
  }

  validates_presence_of :user_id, :description, :action
  validates :action, inclusion: { in: ACTIONS.values }

  private

  def sanitize_description
    self.description = self.description.squish
  end
end
