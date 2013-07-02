require 'spec_helper'

describe "Diffl::Diff.to_html" do
  it "does nothing in particular" do
    diff = Diffl::Diff.new(File.read("testdata/diff1.diff"))    
    diff.to_html.strip.should == File.read("testdata/diff1.html").strip
  end
end