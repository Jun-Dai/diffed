require 'spec_helper'

describe "Diffed::Diff.as_html_table" do
  it "produces an html table representation of a diff, with CSS styles inline" do
    diff = Diffed::Diff.new(File.read("testdata/diff1.diff"))
    output = diff.as_html_table
    output.strip == File.read("testdata/diff1.styled.html").strip
  end
  
  it "produces an html table representation of a diff, with CSS classes" do
    diff = Diffed::Diff.new(File.read("testdata/diff1.diff"))
    output = diff.as_html_table(false)
    output.strip == File.read("testdata/diff1.classed.html").strip
  end  
end