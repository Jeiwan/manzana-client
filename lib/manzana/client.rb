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

    private

    def build_request(operation, body)
      {
        request: {
          operation => merge_with_common_data(body)
        },
        'OrgName' => @org_name
      }
    end

    def merge_with_common_data(body)
      body.merge!(common_data)
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
