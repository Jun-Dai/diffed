require 'spec_helper'

describe "Diffed::Diff.as_html_table" do
  it "produces an html table representation of a diff, with CSS styles inline" do
    diff = Diffed.from_text(File.read("testdata/diff1.diff"))
    output = diff.as_html_table
    # File.open("wtf1.html", "w") {|f| f.write(output)}
    output.strip.should eq File.read("testdata/diff1.styled.html").strip
  end
  
  it "produces an html table representation of the diff portions of the output of 'git show', with CSS styles inline" do
    diff = Diffed.from_text(File.read("testdata/git-show.output"))
    output = diff.as_html_table
    # File.open("wtf2.html", "w") {|f| f.write(output)}
    output.strip.should eq File.read("testdata/git-show.styled.html").strip
  end
  
  it "produces an html table representation of the diff portions of the output of 'p4 describe -du', with CSS styles inline" do
    diff = Diffed.from_text(File.read("testdata/p4-describe.output"))
    output = diff.as_html_table
    # File.open("wtf3.html", "w") {|f| f.write(output)}
    output.strip.should eq File.read("testdata/p4-describe.styled.html").strip
  end
  
  it "produces an html table representation of a diff, with CSS classes" do
    diff = Diffed.from_text(File.read("testdata/diff1.diff"))
    output = diff.as_html_table(false)
    # File.open("wtf4.html", "w") {|f| f.write(output)}
    output.strip.should eq File.read("testdata/diff1.classed.html").strip
  end
  
  it "renders an html table with two highlighted rows, using inline styles" do
    diff = Diffed.from_text(File.read("testdata/diff2.diff"))
    section1 = diff.sections[0]
    output = section1.as_html_table(true, [5, 9,11])
    # File.open("wtf5.html", "w") {|f| f.write(output)}
    output.strip.should eq File.read("testdata/diff2.styled.html").strip
  end
  
  it "renders an html table with two highlighted rows, using CSS classes" do
    diff = Diffed.from_text(File.read("testdata/diff2.diff"))
    section1 = diff.sections[0]
    output = section1.as_html_table(false, [5, 9, 11])
    # File.open("wtf6.html", "w") {|f| f.write(output)}
    output.strip.should eq File.read("testdata/diff2.classed.html").strip
  end
end