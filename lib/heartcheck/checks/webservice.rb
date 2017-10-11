module Heartcheck
  module Checks
    # Check for a webservice service
    # Base is set in heartcheck gem
    class Webservice < Base
      # validate each service
      #
      # @retun [void]
      def validate
        services.each do |service|
          execute service
        end
      end

      private

      DEFAULT_OPEN_TIMEOUT = 3
      DEFAULT_READ_TIMEOUT = 5
      private_constant :DEFAULT_OPEN_TIMEOUT, :DEFAULT_READ_TIMEOUT

      # customize the error message
      # It's called in Heartcheck::Checks::Base#append_error
      #
      # @param name [String] An identifier of service
      # @param key_error [Symbol] name of action
      #
      # @return [void]
      def custom_error(name, key_error)
        @errors << "#{name} fails to #{key_error}"
      end

      # execute and validation request
      #
      # @param service [Hash] An identifier of service
      #
      # @return [void]
      def execute(service)
        response = request_for(service)
        error = valid?(response, service)

        append_error(service, error) if error
      rescue SocketError
        append_error service, 'inaccessible'
      rescue Timeout::Error
        append_error service, 'timeout'
      rescue => e
        append_error service, e.message
      end

      # validate response
      #
      # @param response [Net:HTTP] HTTP response
      # @param service [Hash] An identifier of service
      #
      # @return [String]
      def valid?(response, service)
        return nil if valid_status?(response) && valid_body?(response, service)
        'unexpected_response'
      end

      # validate if response is Net::HTTPSuccess
      #
      # @param response [Net:HTTP] HTTP response
      #
      # @return [Bollean]
      def valid_status?(response)
        response.is_a?(Net::HTTPSuccess)
      end

      # validate if response body contains body_match params
      #
      # @param response [Net:HTTP] HTTP response
      # @param service [Hash] An identifier of service
      #
      # @return [Bollean]
      def valid_body?(response, service)
        service[:body_match] && response.body =~ service[:body_match]
      end

      # execute request
      #
      # @param service [Hash] An identifier of service
      #
      # @return [Net:HTTP]
      def request_for(service)
        Heartcheck::Webservice::HttpClient.new(
          service[:url],
          service[:proxy],
          service[:ignore_ssl_cert],
          service[:headers],
          service.fetch(:open_timeout, DEFAULT_OPEN_TIMEOUT),
          service.fetch(:read_timeout, DEFAULT_READ_TIMEOUT)
        ).get
      end
    end
  end
end
