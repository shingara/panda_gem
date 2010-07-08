require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Panda::Profile do
  before(:each) do
    Time.stub!(:now).and_return(mock("time", :iso8601 => "2009-11-04T17:54:11+00:00"))

    cloud_json = "{\"s3_videos_bucket\":\"my_bucket\",\"id\":\"my_cloud_id\"}" 
    stub_http_request(:get, /http:\/\/myapihost:85\/v2\/clouds\/my_cloud_id.json/).to_return(:body => cloud_json)

    Panda.configure do |c|
      c.access_key = "my_access_key"
      c.secret_key = "my_secret_key"
      c.api_host = "myapihost"
      c.cloud_id = 'my_cloud_id'
      c.api_port = 85
    end
    
  end

  it "should create a video" do
    profile_json = "{\"title\":\"my_profile\",\"id\":\"123\"}"
    stub_http_request(:post, /http:\/\/myapihost:85\/v2\/profiles.json/).
      with(:title =>"my_profiles").
        to_return(:body => profile_json)

    profile = Panda::Profile.new(:title => "http://a.b.com/file.mp4")
    
    profile.new?.should == true
    profile.save.should == true
    profile.id.should == "123" 
    profile.new?.should == false
  end

  it "should not call update a video" do
    profile_json = "{\"title\":\"my_profile\",\"id\":\"123\"}"
    stub_http_request(:put, /http:\/\/myapihost:85\/v2\/profiles\/123.json/).
      with(:title =>"my_profiles").
        to_return(:body => profile_json)

    profile = Panda::Profile.new(:title => "http://a.b.com/file.mp4", :id => "123")
    
    profile.new?.should == false
    profile.save.should == true
  end

end