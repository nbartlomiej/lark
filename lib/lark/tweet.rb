require 'open-uri'
require 'fileutils'

module Lark
  class Tweet
    def initialize item
      @status = get_status(item)
      @file = get_file(item)
    end

    attr_reader :status, :file

    private

    def get_status(item)
      status_text = ellipsis("#{item.title} #{item.description}", 80)
      "#{status_text} #{item.link}"
    end

    def ellipsis(string, length)
      if string.length > length
        terminator = "..."
        stop = length - terminator.length
        "#{string[0, stop]}#{terminator}"
      else
        string
      end
    end

    def get_file(item)
      filepath = './tmp/image.png'
      FileUtils.mkdir_p('tmp')
      Kernel.open(filepath, 'w+') do |file|
        file << Kernel.open(item.enclosure.url).read
      end
      return File.new(filepath)
    end
  end
end
