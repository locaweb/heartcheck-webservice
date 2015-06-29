# enconding: utf-8
module Heartcheck
  module Webservice
    # Http Client
    class HttpClient
      attr_reader :uri, :http, :proxy, :headers, :request, :open_timeout, :read_timeout

      def initialize(url, proxy, ignore_ssl_cert, headers, open_timeout = nil, read_timeout = nil)
        @uri = URI(url)
        @headers = headers || {}
        @proxy = URI(proxy) if proxy

        @http = Net::HTTP.new(@uri.host, @uri.port, proxy_host, proxy_port)
        @http.use_ssl = @uri.scheme == 'https'
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE if ignore_ssl_cert
        @http.open_timeout = open_timeout if open_timeout
        @http.read_timeout = read_timeout if read_timeout
      end

      def get
        @request = Net::HTTP::Get.new(uri.request_uri)

        headers.each { |k, v| request[k] = v }

        http.request request
      end

      private

      def proxy_host
        proxy.host if proxy
      end

      def proxy_port
        proxy.port if proxy
      end
    end
  end
end
