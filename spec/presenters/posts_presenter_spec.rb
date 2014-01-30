require 'spec_helper'

describe PostsPresenter do
  subject { presenter }
  let(:presenter) { PostsPresenter.new(post, viewer.key, viewer_longitude, viewer_latitude) }
  
  let(:post) do
    Post.new(:user_key  => post_author_user_key,
             :longitude => post_longitude,
             :latitude  => post_latitude).tap do |p|
      p.set_user_hash
    end
  end
  
  let(:post_author_user_key) { 'panda' }
  let(:post_longitude) { -120 }
  let(:post_latitude) { 34 }
  
  let(:viewer) { User.new(:key => viewer_user_key) }
  let(:viewer_longitude) { -123 }
  let(:viewer_latitude) { 33 }
  
  context 'when viewer is not the post author' do
    let(:viewer_user_key) { 'pigeon' }
    
    its(:as_json) do
      should eq({
        :can_edit => false,
        :content => nil,
        :created_at => nil,
        :direction => :E,
        :distance => {:meters=>100}, #TODO: the distance is wrong!
        :existing_vote => 0,
        :id => nil,
        :latitude => 34.0,
        :longitude => -120.0,
        :net_upvotes => 0,
        :updated_at => nil            
      })
    end
  end
  
  context 'when viewer is the post author' do
    let(:viewer_user_key) { post_author_user_key }
    
    describe "the json" do
      subject { presenter.as_json }
      its([:can_edit]) { should be_true }
    end
  end
end
