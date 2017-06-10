require "spec_helper"

RSpec.describe HttpResponseTofs do

  let(:url) { 'http://ttttest.com' }

  it "has a version number" do
    expect(HttpResponseTofs::VERSION).not_to be nil
  end

  describe '#open' do
    describe 'integration spec' do
      before do
        @integration_spec_url = 'http://google.com'
        HttpResponseTofs.cache_dir = './lib/http_cache/'
        @local_cache_path = HttpResponseTofs.to_local_path(@integration_spec_url)
        FileUtils.rm_rf(@local_cache_path)
      end
      it 'be success' do
        HttpResponseTofs.open(@integration_spec_url)
        expect(File.exists?(@local_cache_path)).to eq(true)
        # fast
        1000.times do
          expect(HttpResponseTofs.open(@integration_spec_url)).to be_a(File)
        end
      end
    end

    context 'when has cache' do
      context 'when try to open' do
        it 'write to file' do
          HttpResponseTofs.cache_dir = './lib/http_cache/'
          allow(HttpResponseTofs).to receive(:get).exactly(1).times.and_return(true)
          HttpResponseTofs.open(url)
        end
      end
    end

    context 'when nothing cache' do
      context 'when try to open' do
        it 'write to file' do
          HttpResponseTofs.cache_dir = './lib/http_cache/'
          allow(HttpResponseTofs).to receive(:get).exactly(2).times.and_return(false)
          allow(HttpResponseTofs).to receive(:set).exactly(1).times
          HttpResponseTofs.open(url)
        end
      end
    end

    context 'when force_write is true' do
      it 'write file' do
        HttpResponseTofs.cache_dir = './lib/http_cache/'
        allow(HttpResponseTofs).to receive(:get).exactly(1).times
        allow(HttpResponseTofs).to receive(:set).exactly(1).times
        HttpResponseTofs.open(url, force_write: true)
      end
    end

    context 'when cache_dir is nil' do
      before do
        HttpResponseTofs.cache_dir = nil
      end
      it 'catch raise' do
        HttpResponseTofs.cache_dir = nil
        expect{
          HttpResponseTofs.open(url)
        }.to raise_error(RuntimeError)
      end
    end
  end
end
