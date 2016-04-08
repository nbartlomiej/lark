require 'lark'

def rss_item(options)
  double('rss_item', {
    title: 'Title',
    description: 'Description',
    link: 'http://www.example.com',
    enclosure: double('enclosure', url: media_url),
  }.merge(options))
end

LONG_TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean nec facilisis quam. Quisque laoreet est eu enim elementum auctor. Donec in leo lectus. Fusce odio nisi, lacinia nec est et, sollicitudin lobortis lectus. Quisque aliquet laoreet tortor, eu pulvinar leo vestibulum posuere."

RSpec.describe Lark::Tweet do
  subject(:tweet) {described_class.new(rss_item(rss_diff))}

  let(:media_url) {double('media_url')}
  let(:media) {double('media')}
  let(:media_data) {double('media_data')}
  let(:filepath) {'./tmp/image.png'}
  let(:file_object) {double('file_object')}

  before(:each) do
    allow(Kernel).to receive(:open).with(filepath, 'w+') do |path, &block|
      block.call(media)
    end
    allow(Kernel).to receive(:open).with(media_url)
      .and_return(double('io', read: media_data))
    allow(media).to receive(:<<).with(media_data)
    allow(FileUtils).to receive(:mkdir_p)
    allow(File).to receive('new').with(filepath)
      .and_return(file_object)
  end

  describe "#status" do
    subject(:status) {tweet.status}

    context "default item" do
      let(:rss_diff){{}}
      it { should eq('Title Description http://www.example.com') }
    end

    context "long title" do
      let(:rss_diff) {{title: LONG_TEXT}}
      it { should eq('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean nec facilisis... http://www.example.com') }
    end

    context "long description" do
      let(:rss_diff) {{description: LONG_TEXT}}
      it { should eq('Title Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean nec fac... http://www.example.com') }
    end

    context "long title and description" do
      let(:rss_diff) {{title: LONG_TEXT, description: LONG_TEXT}}
      it { should eq('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean nec facilisis... http://www.example.com') }
    end
  end

  describe "#file" do
    subject(:file) {tweet.file}
    let(:rss_diff){{}}

    context "file operations" do
      before(:each) do
        file()
      end

      it { expect(FileUtils).to have_received(:mkdir_p).with('tmp') }
      it { expect(media).to have_received(:<<).with(media_data) }
    end

    it { should equal(file_object) }
  end
end
