require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Panda::Video do
  before(:each) do
    cloud_json = "{\"s3_videos_bucket\":\"my_bucket\",\"id\":\"my_cloud_id\"}"
    stub_http_request(:get, /api.example.com:85\/v2\/clouds\/my_cloud_id.json/).
      to_return(:body => cloud_json)

    my_heroku_url = "http://access_key:secret_key@api.example.com:85/my_cloud_id"
    Panda.configure do |c|
      c.heroku = my_heroku_url
    end
  end
  
  it "should get all videos" do
    videos_json = "[]"
    stub_http_request(:get, /api.example.com:85\/v2\/videos.json/).to_return(:body => videos_json)
    
    Panda::Video.all.should be_empty
  end
  
end
