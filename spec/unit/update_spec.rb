require 'lark'

RSpec.describe Lark::Update do
  subject(:update) {Lark::Update.new}

  before(:each) do
  end

  describe "#start" do
    let(:twitter){ double(:twitter, update_with_media: true) }
    let(:url){ "http://www.example.com"}
    let(:guid){double('guid')}
    let(:item){ double(:item, guid: double('guid_wrapper', content: guid)) }
    let(:database){double('database', store: true)}
    let(:tweet){
      double('tweet', status: double('status'), file: double('file'))
    }

    before(:each) do
      allow(Lark::TwitterClientBuilder).to receive(:create) {twitter}
      allow(Lark::RSS).to receive(:new) {double('rss', latest_item: item)}
      allow(Lark::Database).to receive(:new) {database}
      allow(Lark::Tweet).to receive(:new).with(item)
        .and_return(tweet)
      allow(database).to receive(:present?).with(guid)
        .and_return(present?)

      update.start
    end

    let(:have_tweeted) {
      have_received(:update_with_media).with(tweet.status, tweet.file)
    }

    context "latest item not present in database" do
      let(:present?){false}

      it "Publishes latest RSS item" do
        expect(twitter).to have_tweeted
      end

      it "Saves the guid of the item to the database" do
        expect(database).to have_received(:store).with(guid)
      end
    end

    context "latest item already present in database" do
      let(:present?){true}

      it "Does not publish anything" do
        expect(twitter).not_to have_tweeted
      end

    end
  end
end
