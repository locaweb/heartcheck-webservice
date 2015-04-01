require 'spec_helper'

describe Heartcheck::Checks::Webservice do
  let(:url) { 'http://test.com' }
  let(:name) { 'test' }
  let(:service) { { name: name, url: url, body_match: /OK/ } }
  subject do
    described_class.new.tap { |c| c.add_service(service) }
  end

  describe '#validate' do
    context 'when there is no error' do
      before do
        FakeWeb.register_uri(:get, url,
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
  end
end
