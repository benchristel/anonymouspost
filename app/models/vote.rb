class Vote
  include Mongoid::Document
  # attr_accessible :uid, :value, :referendum

  # belongs_to    :referendum
  # after_save    :save_referendum
  # after_destroy :save_referendum

  def self.total
    sum(:value)
  end

  # returns the amount by which the vote total was adjusted
  def self.vote!(voter_uid, referendum, direction)
    vote_delta = 0

    #return 0 unless User.find_by_key user_key
    direction =  1 if direction > 0
    direction = -1 if direction < 0

    vote_to_undo = existing_vote_for_referendum_and_voter_uid(referendum, voter_uid)

    if vote_to_undo
      vote_delta -= vote_to_undo.value
      vote_to_undo.destroy
      referendum.reload
    end

    if direction != 0
      new_vote = create_by_hash_components_and_value(voter_uid, referendum, direction)
      vote_delta += direction
    end
    vote_delta
  end

  def self.find_by_hash_components(voter_uid, referendum)
    Vote.find_by_uid(Vote.generate_hash(voter_uid, referendum))
  end

  def self.create_by_hash_components_and_value(voter_uid, referendum, value)
    Vote.create(:uid => Vote.generate_hash(voter_uid, referendum), :value => value, :referendum => referendum)
  end

  def +(other)
    value + other.value
  end

  def self.existing_vote_for_referendum_and_voter_uid(referendum, voter_uid)
    find_by_hash_components(voter_uid, referendum)
  end

  private
  def save_referendum
    referendum.save!
  end

  private
  def self.generate_hash(voter_uid, referendum)
    first_level = Encryption.sha(voter_uid.to_s + referendum.id.to_s)
    # use the first-level hash as a delimiter to prevent injection-style attacks
    # that could reveal user keys or vote ownership
    Encryption.sha(voter_uid.to_s + first_level + referendum.id.to_s)
  end
end
