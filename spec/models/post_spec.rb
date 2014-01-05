require 'spec_helper'

RSpec::Matchers.define :belong_to do |expected_owner|
  match do |post|
    post.belongs_to? expected_owner
  end
end

describe 'a Post' do
  subject { post }
  
  let(:post) do
    Post.new(attrs).tap do |post|
      post.set_user_hash
    end
  end
  
  let(:attrs) do
    { :user_key  => user_key,
      :longitude => -122,
      :latitude  => 37,
      :content   => 'oh hello there'
    }
  end
  
  context 'created by user A' do
    let(:user_key) { 'user A' }
    
    it { should belong_to 'user A' }
    
    it { should be_editable_by 'user A' }
    
    it { should_not belong_to 'user B' }
    
    it { should_not be_editable_by 'user B' }
  end
end
