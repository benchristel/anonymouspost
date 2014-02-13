class PostsPresenter
  attr_accessor :post, :viewer
  
  def initialize(post, viewer)
    self.post   = post
    self.viewer = viewer
  end
  
  public
  def as_json(options={})
    post.as_json.merge(
      :distance      => {:meters => distance_meters},
      :direction     => direction,
      :can_edit      => can_edit?,
      :existing_vote => existing_vote
    )
  end
  
  public
  def viewer_latitude;  viewer.viewer_latitude  end
  def viewer_longitude; viewer.viewer_longitude end
  def user; viewer.viewer_user end
  
  private
  def distance_meters
    meters_per_radian = 6_371_000
    meters_per_degree = meters_per_radian * Math::PI / 180.0
    
    puts "viewer = #{viewer_latitude.to_f}, #{viewer_longitude.to_f} post = #{post.latitude.to_f}, #{post.longitude.to_f}"
    
    approx = begin
      degrees = Math.sqrt((viewer_latitude.to_f  - post.latitude.to_f) ** 2 + (viewer_longitude.to_f - post.longitude.to_f) ** 2)
      meters = meters_per_degree * degrees
    end
    
    if approx > 1000
      d_lat  = (viewer_latitude.to_f  - post.latitude.to_f)  * Math::PI / 180.0
      d_long = (viewer_longitude.to_f - post.longitude.to_f) * Math::PI / 180.0
      
      post_lat_rads   = post.latitude.to_f   * Math::PI / 180.0
      viewer_lat_rads = viewer_latitude.to_f * Math::PI / 180.0
      
      a = (Math.sin(d_lat/2) ** 2) +
          (Math.sin(d_long/2) ** 2) * Math.cos(post_lat_rads) * Math.cos(viewer_lat_rads);
      radians = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
      meters_per_radian * radians;
    else
      approx
    end
  end
  
  def direction
    vector = [
      post.longitude - viewer_longitude,
      post.latitude  - viewer_latitude,
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
    post.editable_by?(user)
  end
  
  def existing_vote
    Vote.find_by_hash_components(user.key, post).try(:value) || 0
  end
  
  # delegate missing methods to post
  def method_missing(meth, *args, &block)
    post.public_send(meth, *args, &block)
  end
  
  def respond_to?(meth)
    super || post.respond_to?(meth)
  end
end
