class Tag < ActiveRecord::Base

  # @return [Array<String>] An array with all the tag names
  def enum
    Tag.all.pluck(:name)
  end
end
