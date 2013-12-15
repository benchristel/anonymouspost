module Caches  
  def reload
    @caches = {}
    super
  end
  
  def cached
    @caches ||= {}
  end
end
