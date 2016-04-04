require 'lark'
require 'json'

def mock_response(filename)
  {status: 200, body: File.new("spec/mock_responses/#{filename}.xml")}
end

def use_env_variables(options)
  options.each do |key, value|
    cached_value=nil

    before(:all) do
      cached_value = ENV[key]
      ENV[key] = value
    end

    after(:all) do
      ENV[key] = cached_value
    end
  end
end

def tweet_with_id(i)
  tweet =  "Title #{i} Description #{i} http://www.example.com/item/#{i}"
  a_request(:post, "https://api.twitter.com/1.1/statuses/update.json")
    .with( body: { "status" => tweet })
end

RSpec.describe "RSS Publisher" do
  use_env_variables({
    "LARK_FEED_URL" => 'http://www.example.com/rss',
    "LARK_CONSUMER_KEY" => '1',
    "LARK_CONSUMER_SECRET" => '2',
    "LARK_ACCESS_TOKEN" => '3',
    "LARK_ACCESS_TOKEN_SECRET" => '4'
  })

  before(:each) do
    stub_request(:get, "http://www.example.com/rss")
      .with(headers: {
        'Accept'=>'*/*',
        'User-Agent'=>'Ruby'
      })
      .to_return(*responses)

    stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json")
      .with(
        :headers => {
          'Accept'=>'application/json',
          'Authorization'=>/OAuth oauth_consumer_key="1", oauth_nonce="[a-f0-9]+", oauth_signature="[A-Za-z0-9%]+", oauth_signature_method="HMAC-SHA1", oauth_timestamp="[0-9]+", oauth_token="3", oauth_version="1.0"/,
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'TwitterRubyGem/5.16.0'
        })
      .to_return(
        :status => 200,
        :body => { "id" => 100000000000000000, }.to_json,
        :headers => {}
      )

    Lark::Update.new.start
  end

  let(:response) { mock_response('rss') }

  context "Single request" do
    let(:responses) { [response] }

    it { expect(tweet_with_id(2)).to have_been_made.once }
  end

  context "Multiple requests" do
    let(:responses) { [response, response2] }

    before(:each) do
      Lark::Update.new.start
    end

    context "One new item added" do
      let(:response2) { mock_response('rss_updated_with_one_new_item') }

      it { expect(tweet_with_id(2)).to have_been_made.once }
      it { expect(tweet_with_id(3)).to have_been_made.once }
    end

    context "Two new items added" do
      let(:response2) { mock_response('rss_updated_with_two_new_items') }

      it { expect(tweet_with_id(2)).to have_been_made.once }
      it { expect(tweet_with_id(4)).to have_been_made.once }
    end

    context "Nothing new added" do
      let(:response2) { mock_response('rss') }

      it { expect(tweet_with_id(2)).to have_been_made.once }
    end
  end
end
