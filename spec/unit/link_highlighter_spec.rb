require 'spec_helper'

describe LinkHighlighter do
  subject { LinkHighlighter.new(text) }
  
  context "on text with no link" do
    let(:text) { "abcd" }
    its(:to_s) { should == 'abcd' }
  end
  
  context "on 'www.google.com'" do
    let(:text) { "www.google.com" }
    its(:to_s) { should == '<a href="http://www.google.com">www.google.com</a>' }
  end
  
  context "with a link with 'http://' prefixed" do
    let(:text) { "http://www.google.com" }
    its(:to_s) { should == '<a href="http://www.google.com">http://www.google.com</a>' }
  end
  
  context "with a link with 'https://' prefixed" do
    let(:text) { "https://www.google.com" }
    its(:to_s) { should == '<a href="https://www.google.com">https://www.google.com</a>' }
  end
  
  context "with a link surrounded by other text" do
    let(:text) { 'Go to Google: www.google.com -- or else!' }
    its(:to_s) { should == 'Go to Google: <a href="http://www.google.com">www.google.com</a> -- or else!' }
  end
  
  context "with a link with no www subdomain" do
    let(:text) { "google.com" }
    its(:to_s) do
      pending "decide if this is actually a feature"
      should == '<a href="http://google.com">google.com</a>'
    end
  end
  
  context "with an emoticon" do
    let(:text) { "o.o" }
    its(:to_s) { should == 'o.o' }
  end
end
