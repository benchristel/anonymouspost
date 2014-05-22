module Voting
  extend ActiveSupport::Concern

  included do |base|
    base.belongs_to :referendum
    base.has_many   :votes, :through => :referendum
    base.before_create :save_referendum
  end

  def initialize(*args)
    super.tap do
      self.referendum ||= Referendum.new
    end
  end

  def save_referendum
    referendum.save
  end

  def vote_total
    referendum.vote_total
  end
end
