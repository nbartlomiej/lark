require 'rss'
require 'open-uri'

module Lark
  class RSS
    def latest_item
      items.sort_by(&:pubDate).last
    end

    private

    def items
      Kernel.open(ENV["LARK_FEED_URL"]) do |rss|
        return ::RSS::Parser.parse(rss).items
      end
    end
  end
end
