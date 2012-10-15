require 'spec_helper'

describe User do
  let(:valid_key) { "validkey" }
  let(:invalid_key) { "invalidkey" }
  let(:user) { User.first }
  
  before do
    User.delete_all
    User.create!({:key=>valid_key})
  end
  
  describe "#has_key?" do
    context "with valid key" do
      it "returns true" do
        user.has_key?(valid_key).should eq true
      end
    end
    context "with invalid key" do
      it "returns false" do
        user.has_key?(invalid_key).should eq false
      end
    end
  end
  
  describe ".exists_with_key" do
    context "with valid key" do
      it "returns true" do
        User.exists_with_key?(valid_key).should eq true
      end
    end
    context "with invalid key" do
      it "returns false" do
        User.exists_with_key?(invalid_key).should eq false
      end
    end
  end
end
