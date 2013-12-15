require 'spec_helper'

describe 'when I view a list of posts, it' do
  let(:user_key) { 'marzipanBear$246' }
  let(:me) { Odin.sign_in(user_key) }
  let(:longitude) { -122 }
  let(:latitude) { 33 }
  let(:content) { 'hi' }
  
  subject(:posts) { me.list_posts_within(meters=100, of=longitude,latitude) }
  
  it "displays upvoted posts above posts with no votes" do
    me.post(:content => content, :longitude => longitude, :latitude => latitude)
    me.post(:content => content, :longitude => longitude, :latitude => latitude)
    me.upvote(Post.last.id)
    
    puts Post.count
    puts Post.all.inspect
    
    posts.first.vote_total.should == 1
    posts.last.vote_total.should == 0
  end
  
  it "displays posts with no votes above downvoted posts" do
    me.post(:content => content, :longitude => longitude, :latitude => latitude)
    me.post(:content => content, :longitude => longitude, :latitude => latitude)
    me.downvote(Post.last.id)
    
    posts.first.vote_total.should == 0
    posts.last.vote_total.should == -1
  end
  
  it "displays new posts above old posts" do
    me.post(:content => content, :longitude => longitude, :latitude => latitude)
    me.post(:content => content, :longitude => longitude, :latitude => latitude)
    
    
  end
  
  xit "displays nearby posts above distant posts" do
    
  end
end
