require 'digest'

module Encryption
  def self.sha(s)
    Digest::SHA2.hexdigest(s.to_s)
  end
end
