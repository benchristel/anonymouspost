require 'spec_helper'

describe 'As a User' do
  let(:user_key) { 'marzipanBear$246' }

  describe 'signing up with a new user key' do
    it "creates a user" do
      expect { Odin.sign_up(user_key) }.to change { User.count }.by(1)
    end
  end

  describe 'signing up with an existing user key' do
    before { Odin.sign_up(user_key) }

    it "does not create a user" do
      expect { Odin.sign_up(user_key) }.not_to change { User.count }
    end
  end

  describe 'trying to sign in with a nonexistent user key' do
    it "does not create a user" do
      expect { Odin.sign_in(user_key) }.not_to change { User.count }
    end

    it "does not sign me in" do
      expect( Odin.sign_in(user_key).user ).to be_nil
    end
  end

  describe 'signing in with an existing user key' do
    before { Odin.sign_up(user_key) }

    it "finds the existing User record" do
      expect{ Odin.sign_in(user_key) }.not_to change { User.count }
      expect( Odin.sign_in(user_key).user ).to be_a User
    end
  end

  describe 'posting' do
    let(:content) { 'i fell asleep' }
    let(:me) { Odin.sign_up(user_key) }

    let(:post) do
      me.post(:content => content, :longitude => longitude, :latitude => latitude)
    end

    let(:longitude) { -122 }; let(:latitude) { 33 }

    it "creates a post" do
      expect { post }.to change { Post.count }.from(0).to(1)
    end

    it "persists the message" do
      post.content.should == content
    end

    it "says I can edit the post" do
      post
      expect(Post.last).to be_editable_by user_key
    end
  end

  context "trying to delete a post" do
    let(:me) { Odin.sign_up(user_key) }
    before { owner.post(:content => '', :longitude => 1, :latitude => 1) }

    context "owned by me" do
      let(:owner) { me }

      it 'removes the post' do
        expect { me.delete(Post.last.id) }.to change { Post.count }.from(1).to(0)
      end
    end

    context "owned by someone else" do
      let(:owner) { Odin.sign_up('crackmonkey79') }

      it 'does not remove the post' do
        expect { me.delete(Post.last.id) }.not_to change { Post.count }
      end
    end
  end

  context "when I vote on a post, it" do
    let(:content) { 'i fell asleep' }
    let(:me)    { Odin.sign_up('user1') }
    let(:user2) { Odin.sign_up('user2') }
    let(:user3) { Odin.sign_up('user3') }

    let(:post) do
      Odin.sign_up('otheruser').post(:content => content, :longitude => -122, :latitude => 33)
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
