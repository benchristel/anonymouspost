class TwitterApi
  attr_accessor :client
  
  def initialize
    self.client = Twitter::REST::Client.new do |cfg|
      cfg.consumer_key        = config.consumer_key
      cfg.consumer_secret     = config.consumer_secret
      cfg.access_token        = config.access_token
      cfg.access_token_secret = config.access_token_secret
    end
    
    client.connection_options[:request][:timeout] = 120
    client.connection_options[:request][:open_timeout] = 60
  end
  
  def local_tweets(lat, long, meters_radius)
    km_radius = (meters_radius / 1000).round.to_i
    geocode = "#{lat},#{long},#{km_radius}km"
    client.search("", :geocode => geocode, :result_type => "recent", :count => 10).take(10)
  end
  
  def config
    AppConfig.twitter
  end
end
