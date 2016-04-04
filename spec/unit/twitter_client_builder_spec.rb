require 'lark'

RSpec.describe Lark::TwitterClientBuilder do
  context ".create" do
    subject(:create) { described_class.create }

    let(:twitter){double('twitter')}

    before(:each) do
      allow(ENV).to receive(:[]).with("LARK_CONSUMER_KEY").and_return('1')
      allow(ENV).to receive(:[]).with("LARK_CONSUMER_SECRET").and_return('2')
      allow(ENV).to receive(:[]).with("LARK_ACCESS_TOKEN").and_return('3')
      allow(ENV).to receive(:[]).with("LARK_ACCESS_TOKEN_SECRET").and_return('4')

      allow(Twitter::REST::Client).to receive(:new) {twitter}
    end

    it { should equal(twitter) }

    it "Uses appropriate ENV variables" do
      create()

      expect(Twitter::REST::Client).to have_received(:new)
        .with({
          consumer_key: '1',
          consumer_secret: '2',
          access_token: '3',
          access_token_secret: '4'
        })
    end
  end
end
