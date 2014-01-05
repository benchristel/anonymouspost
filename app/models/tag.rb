class Tag < ActiveRecord::Base
  attr_accessible :text

  def self.find_or_create(args)
    find_by_text(args[:text]) || create!(args)
  end
end
