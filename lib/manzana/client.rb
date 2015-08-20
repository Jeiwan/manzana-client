module Manzana
  class Client
    include Operations

    def initialize(wsdl:, basic_auth: false, organization:, business_unit:, pos:, org_name:, logger: nil)
      @client = Savon.client do
        wsdl wsdl
        if basic_auth
          basic_auth basic_auth
        end
        ssl_verify_mode :none
        unless logger.nil?
          log true
          logger logger
        end
      end

      @organization = organization
      @business_unit = business_unit
      @pos = pos
      @org_name = org_name
    end

    def balance_request(card_number:)
      body = {
        'Card' => {
          'CardNumber' => card_number
        }
      }
      operation = 'BalanceRequest'
      response = @client.call(:process_request, message: build_request(operation, body))
      parse_response(response.body, operation)
    end

    def cheque_request(type: 'Soft', cheque:)
      operation = 'ChequeRequest'
      response = @client.call(:process_request, message: build_request(operation, cheque, { 'ChequeType' => type }))
      parse_response(response.body, operation)
    end

    private

    def parse_response(response, operation)
      operation.gsub!('Request', 'Response').gsub!(/([^A-Z])([A-Z]+)/, '\1_\2').downcase!
      response[:process_request_response][:process_request_result][operation.to_sym]
    end

    def build_request(operation, body, argument = nil)
      request = {
        request: {
          operation => merge_with_common_data(body)
        },
        'orgName' => @org_name
      }

      if argument
        request[:request][operation].merge!("@#{argument.keys[0]}" => argument.values[0])
      end

      request
    end

    def merge_with_common_data(body)
      body.merge!(common_data)

      if body['ChequeReference']
        body['ChequeReference'].merge!(
          'Organization' => @organization,
          'BusinessUnit' => @business_unit,
          'POS' => @pos
        )
      end

      body
    end

    def generate_request_id
      1234
    end

    def common_data
      {
        'RequestID' => generate_request_id,
        'Organization' => @organization,
        'DateTime' => DateTime.now.iso8601,
        'BusinessUnit' => @business_unit,
        'POS' => @pos
      }
    end
  end
end
