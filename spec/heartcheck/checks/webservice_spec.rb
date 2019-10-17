require 'spec_helper'

describe Heartcheck::Checks::Webservice do
  let(:url) { 'http://test.com' }
  let(:name) { 'test' }
  let(:service) { { name: name, url: url } }
  subject do
    described_class.new.tap { |c| c.add_service(service) }
  end

  describe '#uri_info' do
    let(:another_service) { { name: 'someservice', url: 'https://another.com', body_match: /OK/ } }

    before do
      subject.add_service(another_service)
    end

    context 'when uri data is provided' do
      it 'returns proper URI info for each checked webservice' do
        response = subject.uri_info
        expect(response).to eq([
                                 { host: 'test.com', port: 80, scheme: 'http' },
                                 { host: 'another.com', port: 443, scheme: 'https' }
                               ])
      end
    end
  end

  describe '#validate' do
    context 'when there is no error' do
      let(:another_service) { {name: 'anotherservice', url: 'https://myservice.com', body_match: /OK/ } }

      before do
        subject.add_service(another_service)
        FakeWeb.register_uri(:get, /#{url}|#{another_service[:url]}/,
                             body: 'OK',
                             status: '200')
        subject.validate
      end

      it 'array errors should be empty' do
        expect(subject.instance_variable_get(:@errors)).to be_empty
      end
    end

    context 'when there is a error' do
      let(:http_client) { Heartcheck::Webservice::HttpClient }
      before do
        allow_any_instance_of(http_client).to receive(:get).and_raise(error)
        subject.validate
      end

      after do
        expect(subject.instance_variable_get(:@errors).first).to include(url)
      end

      context 'when throw SocketError error' do
        let(:error) { SocketError.new }
        let(:error_return) { 'inaccessible' }

        it 'returns inaccessible' do
          obj = subject.instance_variable_get(:@errors)
          expect(obj.first).to include error_return
        end
      end

      context 'when throw Timeout error' do
        let(:error) { Timeout::Error.new }
        let(:error_return) { 'timeout' }

        it 'returns timeout' do
          obj = subject.instance_variable_get(:@errors)
          expect(obj.first).to include error_return
        end
      end

      context 'when throw unexpected error' do
        let(:error) { StandardError.new('error message') }
        let(:error_return) { 'error message' }

        it 'returns exceptions message' do
          obj = subject.instance_variable_get(:@errors)
          expect(obj.first).to include error_return
        end
      end
    end

    context 'setting timeout on http client' do
      it 'sets a default value when it is not given' do
        net_http_spy = spy('Net::HTTP')
        allow(Net::HTTP).to receive(:new).and_return(net_http_spy)

        check = described_class.new
        check.add_service(name: name, url: url, body_match: /OK/)

        check.validate

        expect(net_http_spy).to have_received(:open_timeout=).with(3)
        expect(net_http_spy).to have_received(:read_timeout=).with(5)
      end

      it 'uses the given value' do
        net_http_spy = spy('Net::HTTP')
        allow(Net::HTTP).to receive(:new).and_return(net_http_spy)

        check = described_class.new
        check.add_service(
          name: name,
          url: url,
          body_match: /OK/,
          open_timeout: 5,
          read_timeout: 6
        )

        check.validate

        expect(net_http_spy).to have_received(:open_timeout=).with(5)
        expect(net_http_spy).to have_received(:read_timeout=).with(6)
      end
    end
  end
end
