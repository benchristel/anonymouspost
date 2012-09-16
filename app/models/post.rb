class Post < ActiveRecord::Base
  attr_accessible :content, :hash, :latitude, :longitude, :timestamp
end
