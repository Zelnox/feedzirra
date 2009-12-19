require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

shared_examples_for "Feedzirra::Parser::RSSEntry" do
  before(:each) do
    # I don't really like doing it this way because these unit test should only rely on RSSEntry,
    # but this is actually how it should work. You would never just pass entry xml straight to the AtomEnry
    @entry = Feedzirra::Parser::RSS.parse(sample_rss_feed).entries.first
  end
  
  it "should parse the title" do
    @entry.title.should == "Nokogiri’s Slop Feature"
  end
  
  it "should parse the url" do
    @entry.url.should == "http://tenderlovemaking.com/2008/12/04/nokogiris-slop-feature/"
  end
  
  it "should parse the content" do
    @entry.content.should == sample_rss_entry_content
  end
  
  it "should provide a summary" do
    @entry.summary.should == "Oops!  When I released nokogiri version 1.0.7, I totally forgot to talk about Nokogiri::Slop() feature that was added.  Why is it called \"slop\"?  It lets you sloppily explore documents.  Basically, it decorates your document with method_missing() that allows you to search your document via method calls.\nGiven this document:\n\ndoc = Nokogiri::Slop&#40;&#60;&#60;-eohtml&#41;\n&#60;html&#62;\n&#160; &#60;body&#62;\n&#160; [...]"
  end
  
  it "should parse the published date" do
    @entry.published.to_s.should == "Thu Dec 04 17:17:49 UTC 2008"
  end

  it "should parse the categories" do
    @entry.categories.should == ['computadora', 'nokogiri', 'rails']
  end
  
  it "should parse the guid as id" do
    @entry.id.should == "http://tenderlovemaking.com/?p=198"
  end
end

describe "Feedzirra::Parser::RSSEntry with dc:creator" do
  it_should_behave_like "Feedzirra::Parser::RSSEntry"
  
  it "should parse the authors from the dc:creator elements" do
    @entry = Feedzirra::Parser::RSS.parse(sample_rss_feed).entries.first
    @entry.authors.should == ["Aaron Patterson"]
  end
end

describe "Feedzirra::Parser::RSSEntry with author" do
  it_should_behave_like "Feedzirra::Parser::RSSEntry"
  
  it "should parse the author from the sole author element" do
    @entry = Feedzirra::Parser::RSS.parse(sample_rss_feed_with_author).entries.first
    @entry.authors.should == ["aaron@patterson.com (Aaron Patterson)"]
  end
end