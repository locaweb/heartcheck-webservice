# enconding: utf-8
module Heartcheck
  module Webservice
    # Http Client
    class HttpClient
      attr_reader :uri, :http

      def initialize(url, ignore_ssl_cert)
        @uri = URI url
        @http =  Net::HTTP.new(@uri.host, @uri.port)
        @http.use_ssl = @uri.scheme == 'https'
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE if ignore_ssl_cert
      end

      def get
        http.request Net::HTTP::Get.new(uri.request_uri)
      end
    end
  end
end
