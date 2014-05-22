require 'spec_helper'

describe 'As a User' do
  let(:post_author) { Odin.sign_up('post author') }
  let(:me) { Odin.sign_up('me') }

  let!(:post) { post_author.post(:content => 'squirrel', :latitude => 1, :longitude => 1) }

  describe "adding a comment on a post" do
    it "creates the comment" do
      expect { me.comment(:post => post, :content => 'hi', :latitude => 1, :longitude => 1) }.to change { Comment.count }.by(1)
    end

    it "associates the comment with the original post" do
      expect { me.comment(:post => post, :content => 'hi', :latitude => 1, :longitude => 1) }.to change { post.comments.count }.by(1)
    end
  end

  describe "adding a reply to a comment" do
    let!(:comment) { me.comment(:post => post, :content => 'hi', :latitude => 1, :longitude => 1) }

    it "creates the reply" do
      expect { me.comment(:comment => comment, :content => 'bye', :latitude => 1, :longitude => 1) }.to change { Comment.count }.by(1)
    end

    it "associates the reply with the original comment" do
      expect { me.comment(:comment => comment, :content => 'bye', :latitude => 1, :longitude => 1) }.to change { comment.replies.count }.by(1)
    end
  end
end
