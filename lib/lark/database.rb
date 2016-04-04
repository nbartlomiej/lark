require 'mongo'

module Lark
  class Database
    def initialize
      @collection = Mongo::Client.new(ENV["MONGOLAB_URI"])
        .database.collection('rssItems')
    end

    def store(guid)
      collection.insert_one({_id: guid})
    end

    def present?(guid)
      client = Mongo::Client.new(ENV["MONGOLAB_URI"])
      collection = client.database.collection('rssItems')
      collection.find({_id: guid}).any?
    end

    private
    attr_reader :collection
  end
end
