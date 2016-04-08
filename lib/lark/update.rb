module Lark
  class Update
    def start
      database = Lark::Database.new
      item = Lark::RSS.new.latest_item
      id = item.guid.content

      unless database.present?(id)
        publish_tweet(item)
        database.store(id)
      end
    end

    private

    def publish_tweet(item)
      twitter = Lark::TwitterClientBuilder.create
      tweet = Lark::Tweet.new(item)
      twitter.update_with_media(tweet.status, tweet.file)
    end
  end
end
