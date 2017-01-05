class Sprint < ActiveRecord::Base
  belongs_to :team
  has_many :issues

  after_create :update_sprint_percentage!

  validates_presence_of :name

  def update_sprint_percentage!
    total_issues = issues.count
    if !total_issues.zero?
      closed_issues  =
        Issue.where("state <> #{Issue::OPEN}").count

      self.percentage = closed_issues / total_issues.to_f
    else
      self.percentage = 0.0
    end

    self.save
  end
end
