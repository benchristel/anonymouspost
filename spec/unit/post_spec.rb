require 'spec_helper'

describe Post do
  describe ".most_relevant" do
    context "(1, long, lat)" do
      let(:longitude) { -122 }
      let(:latitude)  { 33 }
      before { Post.create(:content => 'hello', :user_key => 'monkey1', :longitude => longitude + 0.01, :latitude => latitude + 0.01) }
      
      it "returns at least 1 post" do
        Post.most_relevant(1, near=longitude, latitude).should have(1).post
      end
    end
  end
end
