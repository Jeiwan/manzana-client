module Manzana
  class LoyaltyService
    include Operations

    def initialize(wsdl:, basic_auth: false, organization: nil, business_unit:, pos:, org_name:, logger: nil, timeout: nil)
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
        pretty_print_xml true

        if timeout
          open_timeout timeout
          read_timeout timeout
        end
      end

      @organization = organization
      @business_unit = business_unit
      @pos = pos
      @org_name = org_name
    end

    def balance_request(card_number: nil, mobile_phone: nil)
      raise ArgumentError, 'missing keyword: card_number or mobile_phone' if [card_number, mobile_phone].all?(&:nil?)

      body = if card_number
        {
          'Card' => {
            'CardNumber' => card_number
          }
        }
      elsif mobile_phone
        {
          'Card' => {
            'MobilePhone' => mobile_phone
          }
        }
      end
      operation = 'BalanceRequest'
      response = @client.call(:process_request, message: build_request(operation, body))
      parse_response(response.body, operation)
    rescue Timeout::Error, Errno::ETIMEDOUT, Errno::ENETUNREACH => e
      process_timeout
    end

    def cheque_request(type: 'Soft', cheque:)
      operation = 'ChequeRequest'
      request = build_request(operation, cheque.data, { 'ChequeType' => type })

      response = @client.call(:process_request, message: request)
      parse_response(response.body, operation)
    rescue Timeout::Error, Errno::ETIMEDOUT, Errno::ENETUNREACH => e
      process_timeout(cheque: cheque.data)
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
          'POS' => @pos,
          'DateTime' => DateTime.now.iso8601
        )
      end

      body
    end

    def generate_request_id
      SecureRandom.hex
    end

    def common_data
      data = {
        'RequestID' => generate_request_id,
        'DateTime' => DateTime.now.iso8601,
        'BusinessUnit' => @business_unit,
        'POS' => @pos
      }

      data['Organization'] = @organization unless @organization.nil?
      data
    end

    def process_timeout(cheque: nil)
      {
        return_code: '-1',
        message: 'Отсутствует подключение к интернету. Повторите попытку позже',
        cheque: cheque
      }
    end
  end
end
