require 'spec_helper'
require 'digest'

class Time
  def self.new
    super
    DateTime.strptime("1337000000",'%s')
  end
end

describe Post do
  before do
    User.delete_all
    Post.delete_all
    User.create(:key => "abadface")
  end
  
  let(:good_attrs) { {:content => "hello", :latitude => 44, :longitude => 122, :user_key => "abadface"} }
  
  describe ".create" do
    context "with valid attributes" do
      it "succeeds" do
        p = Post.create(good_attrs)
        p.xash.should eq Digest::SHA2.hexdigest("abadface1337000000")
        puts p.errors.inspect
        Post.count.should eq 1
      end
    end
    
    context "with blank latitude" do
      it "fails" do
        Post.create(good_attrs.merge(:latitude=>nil))
        Post.count.should eq 0
      end
    end
    
    context "with blank longitude" do
      it "fails" do
        Post.create(good_attrs.merge(:longitude=>nil))
        Post.count.should eq 0
      end
    end
    
    context "with blank user_key" do
      it "fails" do
        Post.create(good_attrs.merge(:user_key=>nil))
        Post.count.should eq 0
      end
    end
    
    context "with invalid user_key" do
      it "fails" do
        Post.create(good_attrs.merge(:user_key=>"invalidkey"))
        Post.count.should eq 0
      end
    end
  end
end
