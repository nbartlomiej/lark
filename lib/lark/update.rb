module Lark
  class Update
    def start
      database = Lark::Database.new
      item = Lark::RSS.new.latest_item
      id = item.guid.content

      unless database.present?(id)
        tweet(item)
        database.store(id)
      end
    end

    private

    def tweet(item)
      twitter = Lark::TwitterClientBuilder.create
      status = "#{item.title} #{item.description} #{item.link}"
      twitter.update(status)
    end
  end
end
