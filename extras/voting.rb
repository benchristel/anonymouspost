module Voting
  def vote_multiplier
    cached[:vote_multiplier] ||=
    vote_total < 0 ?
          Math::E**(vote_total*VOTE_MULTIPLIER_CONSTANT) :
          (vote_total*VOTE_MULTIPLIER_CONSTANT)+1
  end


  VOTE_MULTIPLIER_CONSTANT = 0.25
  private
  def set_vote_total
    @already_set_vote_total ||= begin
      self.vote_total = compute_vote_total
      self.vote_multiplier = vote_total < 0 ?
          Math::E**(vote_total*VOTE_MULTIPLIER_CONSTANT) :
          (vote_total*VOTE_MULTIPLIER_CONSTANT)+1
    end
  end

  private
  def compute_vote_total
    votes.sum(:value)
  end

end
