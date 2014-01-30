class PostsPresenter
  attr_accessor :post, :user_key, :longitude, :latitude
  
  def initialize(post, user_key, longitude, latitude)
    self.post      = post
    self.user_key  = user_key
    self.longitude = longitude.to_f
    self.latitude  = latitude.to_f
  end
  
  public
  def as_json(options={})
    post.as_json.merge(
      :distance      => distance,
      :direction     => direction,
      :can_edit      => can_edit?,
      :existing_vote => existing_vote
    )
  end
  
  private
  def distance
    {:meters => 100}
  end
  
  def direction
    vector = [
      post.longitude - longitude,
      post.latitude  - latitude,
    ]
    
    return :HERE if vector[0].abs < 0.001 && vector[1].abs < 0.001
    
    { :N  => [ 0.0,    1.0  ],
      :NE => [ 0.707,  0.707],
      :E  => [ 1.0,    0.0  ],
      :SE => [ 0.707, -0.707],
      :S  => [ 0.0,   -1.0  ],
      :SW => [-0.707, -0.707],
      :W  => [-1.0,    0.0  ],
      :NW => [-0.707,  0.707],
      # CATSBY: Where do balloons go, Twisp?
      # TWISP: *Away*.
    }.inject([:AWAY, 1_000_000]) do |closest, pair|
      k, v = pair
      dist_squared = (vector[0] - v[0])**2 + (vector[1] - v[1])**2
      if dist_squared < closest[1]
        [k, dist_squared]
      else
        closest
      end
    end[0]
  end
  
  def can_edit?
    post.editable_by?(user_key)
  end
  
  def existing_vote
    Vote.find_by_hash_components(user_key, post).try(:value) || 0
  end
  
  # delegate missing methods to post
  def method_missing(meth, *args, &block)
    post.public_send(meth, *args, &block)
  end
  
  def respond_to?(meth)
    super || post.respond_to?(meth)
  end
end
