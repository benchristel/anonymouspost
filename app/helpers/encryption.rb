require 'digest'

module Encryption
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  protected
  
  module ClassMethods
    def sha(s)
      Digest::SHA2.hexdigest(s.to_s)
    end
  end
end
