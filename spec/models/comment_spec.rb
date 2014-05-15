require 'spec_helper'

describe Comment do
  let(:comment) { described_class.new }
  
  it "has many replies" do
    comment.replies.should be_an Array
  end
  
  it "belongs to one post" do
    expect { comment.post }.not_to raise_error
  end
  
  it "belongs to a parent comment" do
    expect { comment.parent }.not_to raise_error
  end
end
