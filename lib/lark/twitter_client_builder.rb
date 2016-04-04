require 'twitter'

module Lark
  class TwitterClientBuilder
    def self.create
      Twitter::REST::Client.new(
        consumer_key: ENV["LARK_CONSUMER_KEY"],
        consumer_secret: ENV["LARK_CONSUMER_SECRET"],
        access_token: ENV["LARK_ACCESS_TOKEN"],
        access_token_secret: ENV["LARK_ACCESS_TOKEN_SECRET"]
      )
    end
  end
end
