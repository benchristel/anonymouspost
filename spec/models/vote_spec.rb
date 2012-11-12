require 'spec_helper'

describe Vote do
  let(:post_attrs) { {:content => "hello", :latitude => 44, :longitude => 122, :user_key => "alice"} }
  
  
  before do
    @alice = User.create :key => 'alice'
    @bob = User.create :key => 'bob'
  end
  
  describe 'vote!' do
    it 'allows user to upvote a post' do
      p = Post.create post_attrs
      Vote.vote!('alice', p, 1).should eq true
      p.vote_total.should eq 1
    end
    
    it 'allows user to downvote a post' do
      p = Post.create post_attrs
      Vote.vote!('alice', p, -1).should eq true
      p.vote_total.should eq -1
    end
    
    it 'allows user to upvote then downvote a post' do
      p = Post.create post_attrs
      Vote.vote!('alice', p, 1).should eq true
      Vote.vote!('alice', p, -1).should eq true
      p.vote_total.should eq -1
    end
    
    it 'allows user to downvote then upvote a post' do
      p = Post.create post_attrs
      Vote.vote!('alice', p, -1).should eq true
      Vote.vote!('alice', p, 1).should eq true
      p.vote_total.should eq 1
    end
    
    it 'allows user to reset their vote to neutral' do
      p = Post.create post_attrs
      Vote.vote!('alice', p, 1).should eq true
      Vote.vote!('alice', p, 0).should eq true
      p.vote_total.should eq 0
    end
    
    it 'allows user to reset their vote to neutral' do
      p = Post.create post_attrs
      Vote.vote!('alice', p, -1).should eq true
      Vote.vote!('alice', p, 0).should eq true
      p.vote_total.should eq 0
    end
    
    it 'allows multiple users to vote' do
      p = Post.create post_attrs
      Vote.vote!('alice', p, 1).should eq true
      Vote.vote!('bob', p, 1).should eq true
      p.vote_total.should eq 2
    end
    
    it 'does not allow nonexistent users to vote' do
      p = Post.create post_attrs
      Vote.vote!('asldkw', p, 1).should eq false
      p.vote_total.should eq 0
    end
  end
  
end
