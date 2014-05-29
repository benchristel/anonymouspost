module Voting
  extend ActiveSupport::Concern

  included do |base|
    base.belongs_to :referendum
    base.has_many   :votes, :through => :referendum
    base.before_create :save_referendum
    base.after_initialize :initialize_referendum
  end

  def initialize_referendum
    self.referendum ||= Referendum.new
  end

  def save_referendum
    referendum.save
  end

  def vote_total
    referendum.vote_total
  end
end
