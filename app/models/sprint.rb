class Sprint < ActiveRecord::Base
  belongs_to :team

  validates_presence_of :name
end
