require 'spec_helper'

describe 'Viewing a list of posts' do
  let(:user_key) { 'marzipanBear$246' }
  let(:me) { Odin.sign_up(user_key) }
  let(:longitude) { -122 }
  let(:latitude) { 33 }
  let(:content) { 'hi' }

  before { TwitterApi.any_instance.stub(:local_tweets).and_return([]) }

  around do |example|
    Timecop.freeze { example.run }
  end

  after { Timecop.return }

  subject(:posts) { me.list_posts_near(longitude, latitude) }

  it "displays upvoted posts above posts with no votes" do
    me.post(:content => content, :longitude => longitude, :latitude => latitude)
    me.post(:content => content, :longitude => longitude, :latitude => latitude)
    me.upvote(Post.last.id)

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
    me.post(:content => 'old', :longitude => longitude, :latitude => latitude)
    Timecop.travel(2.seconds.from_now)
    me.post(:content => 'new', :longitude => longitude, :latitude => latitude)

    posts.first.content.should == 'new'
  end

  it "displays nearby posts above distant posts" do
    me.post(:content => 'far', :longitude => longitude, :latitude => latitude + 0.01)
    me.post(:content => 'near', :longitude => longitude, :latitude => latitude)

    posts.first.content.should == 'near'
  end

  it "displays tags" do
    me.post(:content => 'Jafar', :longitude => longitude, :latitude => latitude, :tags => ["Brony!"])

    posts.first.tags.first.text.should eq "Brony!"
  end

  it "displays edits" do
    post_id = me.post(:content => 'Jafar', :longitude => longitude, :latitude => latitude, :tags => ["Brony!"])
    me.edit(post_id, :content => "farts butts")

    posts.first.edits.first.content.should eq "farts butts"
  end
end
