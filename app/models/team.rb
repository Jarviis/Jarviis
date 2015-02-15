class Team < ActiveRecord::Base
  has_many :team_relationships
  has_many :users, through: :team_relationships
  has_many :sprints

  before_save :upercase_slug, if: -> { new_record? || slug_changed? }

  validates_presence_of :slug
  validates_uniqueness_of :slug

  def active_sprint
    @active_sprint ||= self.sprints.
      where("starttime <= :starttime AND endtime < :endtime",
            { starttime: Time.now, endtime: Time.now }).first
  end

  private

  def upercase_slug
    self.slug = self.slug.upcase
  end
end
