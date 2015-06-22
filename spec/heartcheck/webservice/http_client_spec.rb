require 'spec_helper'

describe Heartcheck::Webservice::HttpClient do
  let(:url) { 'http://test.com' }
  let(:uri) { URI url }
  let(:subject) { described_class.new(url, nil, false, nil) }
  let(:proxy_path) { 'http://10.20.30.40:8888' }

  describe '#initialize' do
    let(:http) { double.as_null_object }

    context 'with http proxy' do
      it 'initializes Net::HTTP with a proxy configured' do
        expect(Net::HTTP).to receive(:new)
          .with(uri.host, uri.port, '10.20.30.40', 8888)
          .and_return(http)
        described_class.new(url, proxy_path, false, nil)
      end
    end

    context 'when does not ignore ssl cert' do
      it 'initializes Net::Http with correct host and port' do
        expect(Net::HTTP).to receive(:new)
          .with(uri.host, uri.port, nil, nil)
          .and_return(http)
        described_class.new(url, nil, false, nil)
      end

      it 'sets verify_mode as VERIFY_NONE' do
        expect_any_instance_of(Net::HTTP).not_to receive(:verify_mode=)
          .with(OpenSSL::SSL::VERIFY_NONE)
        described_class.new(uri, nil, false, nil)
      end
    end

    context 'when ignore ssl cert' do
      it 'sets verify_mode as VERIFY_NONE' do
        uri = URI('https://test.com')
        expect_any_instance_of(Net::HTTP).to receive(:verify_mode=)
          .with(OpenSSL::SSL::VERIFY_NONE)
        described_class.new(uri, nil, true, nil)
      end
    end

    context 'when timeout' do
      it 'sets timeout' do
        expect_any_instance_of(Net::HTTP).to receive(:open_timeout=)
          .with(2)
        described_class.new(uri, nil, true, nil, 2)
      end
    end
  end

  describe '#get' do
    context 'with headers' do
      subject { described_class.new(url, nil, false, 'X-API-KEY' => '123abc') }

      it 'uses the given headers in the request' do
        expect_any_instance_of(Net::HTTP).to receive(:request)
          .and_return(double)

        subject.get

        expect(subject.request['X-API-KEY']).to eq('123abc')
      end
    end

    it 'calls Net::HTTP::Get' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(double)
      expect(Net::HTTP::Get).to receive(:new).with('/')
      subject.get
    end
  end
end
