module Manzana
  class AccountService
    def initialize(wsdl:, basic_auth: false, organization:, business_unit:, pos:, org_name:, logger: nil, timeout: nil)
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

    def contact_registration(mobile_phone:, card_number:, questionnaire_barcode:)
      parameters = {
        mobile_phone: mobile_phone,
        card_number: card_number,
        questionnaire_barcode: questionnaire_barcode
      }

      send_request(contract: 'contact_registration', parameters: parameters)
    rescue Timeout::Error, Errno::ETIMEDOUT, Errno::ENETUNREACH =>e
      process_timeout
    end

    def complete_registration(contact_id:, temp_code:)
      parameters = {
        contact_id: contact_id,
        temp_code: temp_code
      }

      send_request(contract: 'complete_registration', parameters: parameters)
    rescue Timeout::Error, Errno::ETIMEDOUT, Errno::ENETUNREACH =>e
      process_timeout
    end

    def registration_code_send(contact_id:)
      parameters = {
        contact_id: contact_id
      }

      send_request(contract: 'registration_code_send', parameters: parameters)
    rescue Timeout::Error, Errno::ETIMEDOUT, Errno::ENETUNREACH =>e
      process_timeout
    end

    def rollback_registration(contact_id:)
      parameters = {
        contact_id: contact_id
      }

      send_request(contract: 'rollback_registration', parameters: parameters)
    rescue Timeout::Error, Errno::ETIMEDOUT, Errno::ENETUNREACH =>e
      process_timeout
    end

    def card_replace(card_number:, mobile_phone:)
      parameters = {
        card_number: card_number,
        mobile_phone: mobile_phone
      }

      send_request(contract: 'card_replace', parameters: parameters)
    rescue Timeout::Error, Errno::ETIMEDOUT, Errno::ENETUNREACH =>e
      process_timeout
    end

    private

    def build_message(contract_name, parameters)
      parameters.merge!(orgunit_external_id: @business_unit)
      parameters = {
        'ServiceContractParameter' => parameters.to_a.map! do |k, v|
          { 'Name' => k.to_s, 'Value' => v }
        end
      }

      {
        'contractName' => contract_name,
        'parameters' => parameters,
        'sessionId' => get_session
      }
    end

    def parse_response(response)
      body = response[:execute_response][:execute_result][:xml_value][:result]
      { code: '0', result: strip_attributes(body) }
    end

    def parse_error(error)
      parser = Nori.new(strip_namespaces: true)
      response = parser.parse(error.http.body)['Envelope']['Body']['Fault']['detail']['details']
      [response['code'], response['description']]
    end

    def get_session
      '{00000000-0000-0000-0000-000000000000}'
    end

    # TODO: Придумать что-нибудь по-умнее
    def strip_attributes(response)
      return response unless response.is_a? Hash
      response.delete_if { |k, v| k == :@xmlns }
    end

    def send_request(contract:, parameters:)
      response = @client.call(:execute, message: build_message(contract, parameters))
      parse_response(response.body)

    rescue Savon::SOAPFault => e
      code, message = parse_error(e)
      { code: code, message: message }
    end

    def process_timeout
      {
        code: '-1',
        message: 'Отсутствует подключение к интернету. Повторите попытку позже',
      }
    end
  end
end
