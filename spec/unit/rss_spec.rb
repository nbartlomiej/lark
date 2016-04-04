require 'lark'

RSpec.describe Lark::RSS do
  subject(:rss) {described_class.new}

  describe "#latest_item" do
    subject(:latest_item) {rss.latest_item}

    let(:url){'http://www.example.com/rss'}
    let(:rss_stream){double('rss_stream')}

    let(:new_item){double('new_item', pubDate: date)}
    let(:old_item){double('old_item', pubDate: date-1)}
    let(:feed){double('feed', items: items)}

    let(:date){DateTime.now}

    before(:each) do
      allow(ENV).to receive(:[]).with("LARK_FEED_URL")
        .and_return(url)
      allow(Kernel).to receive(:open).with(url) do |url, &block|
        block.call(rss_stream)
      end
      allow(RSS::Parser).to receive(:parse).with(rss_stream)
        .and_return(feed)
    end

    context "items sorted" do
      let(:items){[new_item, old_item]}
      it {should equal(new_item)}
    end

    context "items unsorted" do
      let(:items){[old_item, new_item]}
      it {should equal(new_item)}
    end
  end
end
