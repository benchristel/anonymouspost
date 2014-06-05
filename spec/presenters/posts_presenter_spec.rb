require 'spec_helper'

describe PostsPresenter do
  subject { presenter }
  let(:presenter) { PostsPresenter.new(post, viewer, init_options) }
  let(:viewer) do
    double Viewer,
      :viewer_longitude => viewer_longitude,
      :viewer_latitude  => viewer_latitude,
      :viewer_roles     => nil,
      :can_edit?        => viewer_can_edit,
      :existing_vote    => 0
  end

  let(:post) do
    Post.new(:user_key  => post_author_user_key,
             :longitude => post_longitude,
             :latitude  => post_latitude).tap do |p|
      p.set_user_hash
    end
  end

  let(:post_author_user_key) { 'panda' }
  let(:post_longitude) { -122.4193 }
  let(:post_latitude) { 37.7756 }

  let(:viewer_longitude) { -122.143199 }
  let(:viewer_latitude) { 37.442174 }
  let(:init_options) {{:comments => false}}

  context 'when viewer is not the post author' do
    let(:viewer_can_edit) { false }
    its(:as_json) do
      should eq({
        :can_edit => false,
        :content => nil,
        :created_at => nil,
        :direction => :NW,
        :distance => {:meters=>44340.63813856269},
        :existing_vote => 0,
        :id => nil,
        :latitude => post_latitude,
        :longitude => post_longitude,
        :net_upvotes => 0,
        :updated_at => nil,
        :tags => []
      })
    end
  end

  context 'when viewer is the post author' do
    let(:viewer_can_edit) { true }
    describe "the json" do
      subject { presenter.as_json }
      its([:can_edit]) { should be_true }
    end
  end

  context 'when viewer wants to see commments' do
    let(:viewer_can_edit) { false }
    let(:init_options) {{:comments => true}}
    describe "the json" do
      subject { presenter.as_json }
      its([:comments]) { should be_an Array }
    end
  end
end
