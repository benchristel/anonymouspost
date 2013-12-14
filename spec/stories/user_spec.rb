require 'spec_helper'

describe 'As a User,' do
  let(:user_key) { 'marzipanBear$246' }
  context 'when I sign in with a new User Key, it' do
    it "creates a new User record" do
      expect { Odin.sign_in(user_key) }.to change { User.count }.from(0).to(1)
    end
  end
  
  context 'when I sign in with an existing User Key, it' do
    before { Odin.sign_in(user_key) }
    
    it "finds the existing User record" do
      expect{ Odin.sign_in(user_key) }.not_to change { User.count }
      expect( Odin.sign_in(user_key).user ).to be_a User
    end
  end
  
  context 'when I post, it' do
    let(:content) { 'i fell asleep' }
    let(:me) { Odin.sign_in(user_key) }
    
    let(:post) do
      me.post(:content => content, :longitude => -122, :latitude => 33)
    end
    
    it "creates a post" do
      expect { post }.to change { Post.count }.from(0).to(1)
    end
    
    it "persists the message" do
      post.content.should == content
    end
    
    it 'lets me delete the post' do
      post
      expect { me.delete(post.id) }.to change { Post.count }.from(1).to(0)
    end
    
    it "doesn't let any other user delete the post" do
      post
      evil_guy = Odin.sign_in('crackmonkey79')
      expect { evil_guy.delete(post.id) }.not_to change { Post.count }
    end
  end
  
  context "when I vote on a post, it" do
    let(:content) { 'i fell asleep' }
    let(:me)    { Odin.sign_in('user1') }
    let(:user2) { Odin.sign_in('user2') }
    let(:user3) { Odin.sign_in('user3') }
    
    let(:post) do
      Odin.sign_in('otheruser').post(:content => content, :longitude => -122, :latitude => 33)
    end
    
    it "changes the vote count" do
      expect { me.upvote(post.id) }.to change { post.reload.vote_total }.by(1)
    end
    
    it "doesn't record duplicate votes" do
      me.upvote(post.id)
      expect { me.upvote(post.id) }.not_to change { post.reload.vote_total }
    end
    
    it "lets me change my vote" do
      me.upvote(post.id)
      expect { me.downvote(post.id) }.to change { post.reload.vote_total }.from(1).to(-1)
    end
    
    it "lets me remove my vote" do
      me.upvote(post.id)
      expect { me.unvote(post.id) }.to change { post.reload.vote_total }.to(0)
    end
    
    it "lets others vote" do
      me.upvote(post.id)
      expect { user2.upvote(post.id) }.to change { post.reload.vote_total }.by(1)
      expect { user3.downvote(post.id) }.to change { post.reload.vote_total }.by(-1)
    end
    
    it "raises ActiveRecord::RecordNotFound if the post doesn't exist" do
      expect { me.upvote(0) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
