require 'spec_helper'

describe 'As a User,' do
  let(:user_key) { 'marzipanBear$246' }
  context 'when I sign in with a new User Key, it' do
    it "creates a new User record" do
      expect { Odin.sign_in(user_key) }.to change { User.count }.from(0).to(1)
    end
  end
  
  context 'when I sign in with an existing User Key, it' do
    before { Odin.sign_in(user_key) }
    
    it "finds the existing User record" do
      expect{ Odin.sign_in(user_key) }.not_to change { User.count }
      expect( Odin.sign_in(user_key) ).to be_a User
    end
  end
  
  context 'when I post, it' do
    let(:message) { 'i fell asleep' }
    let(:post) do
      Odin.sign_in(user_key)
      Odin.post(:content => message, :user_key => user_key, :longitude => 123, :latitude => 34)
    end
    
    it "creates a post" do
      expect { post }.to change { Post.count }.from(0).to(1)
    end
    
    it "persists the message" do
      post.content.should == message
    end
    
    it 'makes me the owner of the post' do
      expect(Odin.delete(post.id, user_key)).to be_true
    end
  end
end
