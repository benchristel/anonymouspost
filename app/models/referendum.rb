class Referendum
  include Mongoid::Document
  # has_many :votes, :dependent => :delete_all

  # before_validation :update_vote_total

  def update_vote_total
    self.vote_total = votes.total
  end
end
