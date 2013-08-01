require 'spec_helper'

describe "Diffed::Diff.as_html_table" do
  it "produces an html table representation of a diff, with CSS styles inline" do
    diff = Diffed.from_text(File.read("testdata/diff1.diff"))
    output = diff.as_html_table
    output.strip == File.read("testdata/diff1.styled.html").strip
  end
  
  it "produces an html table representation of the diff portions of the output of 'git show', with CSS styles inline" do
    diff = Diffed.from_text(File.read("testdata/git-show.output"))
    output = diff.as_html_table
    output.strip == File.read("testdata/git-show.styled.html").strip
  end
  
  it "produces an html table representation of the diff portions of the output of 'p4 describe -du', with CSS styles inline" do
    diff = Diffed.from_text(File.read("testdata/p4-describe.output"))
    output = diff.as_html_table
    output.strip == File.read("testdata/p4-describe.styled.html").strip
  end
  
  it "produces an html table representation of a diff, with CSS classes" do
    diff = Diffed.from_text(File.read("testdata/diff1.diff"))
    output = diff.as_html_table(false)
    output.strip == File.read("testdata/diff1.classed.html").strip
  end  
end