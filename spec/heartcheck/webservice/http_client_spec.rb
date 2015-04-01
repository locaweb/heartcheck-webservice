require 'spec_helper'

describe Heartcheck::Webservice::HttpClient do
  let(:url) { 'http://test.com' }
  let(:uri) { URI url }
  let(:subject) { described_class.new(url, false) }

  describe '#initialize' do
    let(:http) { double.as_null_object }

    context 'when does not ignore ssl cert' do
      it 'initializes Net::Http with correct host and port' do
        expect(Net::HTTP).to receive(:new)
          .with(uri.host, uri.port)
          .and_return(http)
        described_class.new(url, false)
      end

      it 'sets verify_mode as VERIFY_NONE' do
        expect_any_instance_of(Net::HTTP).not_to receive(:verify_mode=)
          .with(OpenSSL::SSL::VERIFY_NONE)
        described_class.new(uri, false)
      end
    end

    context 'when ignore ssl cert' do
      it 'sets verify_mode as VERIFY_NONE' do
        uri = URI('https://test.com')
        expect_any_instance_of(Net::HTTP).to receive(:verify_mode=)
          .with(OpenSSL::SSL::VERIFY_NONE)
        described_class.new(uri, true)
      end
    end
  end

  describe '#get' do
    it 'calls Net::HTTP::Get' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(double)
      expect(Net::HTTP::Get).to receive(:new).with('/')
      subject.get
    end
  end
end
