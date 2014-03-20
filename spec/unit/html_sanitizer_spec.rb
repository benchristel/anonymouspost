require 'spec_helper'

describe HtmlSanitizer do
  subject { HtmlSanitizer.new(text) }
  
  context "on text with no HTML" do
    let(:text) { "abcd" }
    its(:to_s) { should == 'abcd' }
  end
  
  context "on text with HTML" do
    let(:text) { "<script></script>" }
    its(:to_s) { should == '&lt;script&gt;&lt;/script&gt;' }
  end
end
