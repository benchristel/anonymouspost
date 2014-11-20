class Edit < ActiveRecord::Base
  belongs_to :editable

  attr_accessible :content
end
