require 'lark'

RSpec.describe Lark::Database do
  subject(:database) {described_class.new}

  let(:mongo_uri) {double('mongo_uri')}
  let(:mongo_database) {double('mongo_database')}

  let(:collection){ double('collection') }
  let(:guid){ double('guid') }

  before(:each) do
    allow(ENV).to receive(:[]).with("MONGOLAB_URI")
      .and_return(mongo_uri)
    allow(Mongo::Client).to receive(:new).with(mongo_uri)
      .and_return(double('client', database: mongo_database))
    allow(mongo_database).to receive(:collection).with('rssItems')
      .and_return(collection)
  end

  describe "#store" do
    before(:each) do
      allow(collection).to receive(:insert_one).with({_id: guid})
    end

    it "inserts new item to the database" do
      database.store(guid)
      expect(collection).to have_received(:insert_one)
        .with({_id: guid})
    end
  end

  describe "#present?" do
    before(:each) do
      allow(collection).to receive(:find).with({_id: guid})
        .and_return(double('result', :any? => find_any_result))
    end

    subject(:present?){database.present?(guid)}

    context "item is present" do
      let(:find_any_result) {true}
      it {should equal(true)}
    end

    context "item is not present" do
      let(:find_any_result) {false}
      it {should equal(false)}
    end
  end
end
