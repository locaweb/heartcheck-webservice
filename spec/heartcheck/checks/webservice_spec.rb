RSpec.describe Heartcheck::Checks::Webservice do
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
                             :body => "OK",
                             :status => "200")
        subject.validate
      end

      it 'array errors should be empty' do
        expect(subject.instance_variable_get(:@errors)).to be_empty
      end
    end

    context 'when there is a error' do
      before do
        allow(Net::HTTP).to receive(:get_response).and_raise(error)
        subject.validate
      end

      after do
        expect(subject.instance_variable_get(:@errors).first).to include(url)
      end

      context 'when throw SocketError error' do
        let(:error) { SocketError.new }

        it 'returns inaccessible' do
          expect(subject.instance_variable_get(:@errors).first).to include 'inaccessible'
        end
      end

      context 'when throw Timeout error' do
        let(:error) { Timeout::Error.new }

        it 'returns timeout' do
          expect(subject.instance_variable_get(:@errors).first).to include 'timeout'
        end
      end

      context 'when throw unexpected error' do
        let(:error) { StandardError.new('error message') }

        it 'returns exceptions message' do
          expect(subject.instance_variable_get(:@errors).first).to include 'error message'
        end
      end
    end
  end
end
