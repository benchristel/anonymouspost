require 'spec_helper'

describe 'As a User' do
  let(:post_author) { Odin.sign_up('post author') }
  let(:me) { Odin.sign_up('me') }

  let!(:post) { post_author.post(:content => 'squirrel', :latitude => 1, :longitude => 1) }

  describe "adding a comment on a post" do
    it "creates the comment" do
      expect { me.comment(:post => post, :content => 'hi', :latitude => 1, :longitude => 1, :user_key => 'me') }.to change { Comment.count }.by(1)
    end
  end
end
