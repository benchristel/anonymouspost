class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :location, type: Array

  index location: '2d'

  def as_json(*)
    json = super.slice('content', 'created_at')
    json['created_at'] = json['created_at'].to_i
    json['longitude'] = longitude
    json['latitude'] = latitude
    json
  end

  def longitude
    if self.location
      self.location[0]
    else
      0
    end
  end

  def latitude
    if self.location
      self.location[1]
    else
      0
    end
  end

  def longitude= value
    self.location ||= [0,0]
    self.location[0] = value
  end

  def latitude= value
    self.location ||= [0,0]
    self.location[1] = value
  end

  def self.create_from request_params
    create request_params.require(:post).permit(*mass_assignable_fields)
  end

  def self.mass_assignable_fields
    %w[content]
  end
end
