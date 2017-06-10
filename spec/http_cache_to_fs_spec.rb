require "spec_helper"

RSpec.describe HttpCacheToFs do

  let(:url) { 'http://ttttest.com' }

  it "has a version number" do
    expect(HttpCacheToFs::VERSION).not_to be nil
  end

  describe '#open' do
    describe 'integration spec' do
      before do
        @integration_spec_url = 'http://google.com'
        HttpCacheToFs.cache_dir = './lib/http_cache/'
        @local_cache_path = HttpCacheToFs.to_local_path(@integration_spec_url)
        FileUtils.rm_rf(@local_cache_path)
      end
      it 'be success' do
        HttpCacheToFs.open(@integration_spec_url)
        expect(File.exists?(@local_cache_path)).to eq(true)
        # fast
        1000.times do
          expect(HttpCacheToFs.open(@integration_spec_url)).to be_a(File)
        end
      end
    end

    context 'when has cache' do
      context 'when try to open' do
        it 'write to file' do
          HttpCacheToFs.cache_dir = './lib/http_cache/'
          allow(HttpCacheToFs).to receive(:get).exactly(1).times.and_return(true)
          HttpCacheToFs.open(url)
        end
      end
    end

    context 'when nothing cache' do
      context 'when try to open' do
        it 'write to file' do
          HttpCacheToFs.cache_dir = './lib/http_cache/'
          allow(HttpCacheToFs).to receive(:get).exactly(2).times.and_return(false)
          allow(HttpCacheToFs).to receive(:set).exactly(1).times
          HttpCacheToFs.open(url)
        end
      end
    end

    context 'when force_write is true' do
      it 'write file' do
        HttpCacheToFs.cache_dir = './lib/http_cache/'
        allow(HttpCacheToFs).to receive(:get).exactly(1).times
        allow(HttpCacheToFs).to receive(:set).exactly(1).times
        HttpCacheToFs.open(url, force_write: true)
      end
    end

    context 'when cache_dir is nil' do
      before do
        HttpCacheToFs.cache_dir = nil
      end
      it 'catch raise' do
        HttpCacheToFs.cache_dir = nil
        expect{
          HttpCacheToFs.open(url)
        }.to raise_error(RuntimeError)
      end
    end
  end
end
