module Manzana
  class Client
    def initialize(wsdl:, basic_auth: false, organization:, business_unit:, pos:, org_name:)
      @client = Savon.client(
        wsdl: wsdl,
        basic_auth: basic_auth,
        #convert_request_keys_to: :camelcase
      )

      @organization = organization
      @business_unit = business_unit
      @pos = pos
      @org_name = org_name
    end

    def balance_request(card_number:)
      body = {
        'CardNumber' => card_number
      }
      @client.call(:process_request, message: build_request('BalanceRequest', body))
    end

    def cheque_request(type: 'Soft', cheque:)
      @client.call(:process_request, message: build_request('ChequeRequest', cheque, { 'ChequeType' => type }))
    end

    private

    def build_request(operation, body, argument = nil)
      request = {
        request: {
          operation => merge_with_common_data(body)
        },
        'OrgName' => @org_name
      }

      if arguments
        request[:request][operation].merge!("@#{argument.keys[0]}" => arguments.values[0])
      else
        request
      end
    end

    def merge_with_common_data(body)
      body.merge!(common_data)

      if body['ChequeReference'].present?
        body['ChequeReference'].merge!(
          'Organization' => @organization,
          'BusinessUnit' => @business_unit,
          'POS' => @pos
        )
      else
        body
      end
    end

    def generate_request_id
      1234
    end

    def common_data
      {
        'RequestID' => generate_request_id,
        'Organization' => @organization,
        'BusinessUnit' => @business_unit,
        'POS' => @pos
      }
    end
  end
end
