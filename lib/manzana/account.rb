module Manzana
  class Account
    def initialize(wsdl:, basic_auth: false, organization:, business_unit:, pos:, org_name:, logger: nil)
      @client = Savon.client do
        wsdl wsdl
        basic_auth basic_auth
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

    def contact_registration(mobile_phone:, card_number:, questionnaire_barcode:)
      parameters = {
        mobile_phone: mobile_phone,
        card_number: card_number,
        questionnaire_barcode: questionnaire_barcode
      }

      response = @client.call(:execute, message: build_message('contact_registration', parameters))
      parse_response(response.body)[:contact_id]
    end

    def complete_registration(contact_id:, temp_code:)
      parameters = {
        contact_id: contact_id,
        temp_code: temp_code
      }

      response = @client.call(:execute, message: build_message('complete_registration', parameters))
      parse_response(response.body)
    end

    def registration_code_send(contact_id:)
      parameters = {
        contact_id: contact_id
      }

      response = @client.call(:execute, message: build_message('registration_code_send', parameters))
      parse_response(response.body)
    end

    def rollback_registration(contact_id:)
      parameters = {
        contact_id: contact_id
      }

      response = @client.call(:execute, message: build_message('rollback_registration', parameters))
      parse_response(response.body)
    end

    def card_replace(card_number:, mobile_phone:)
      parameters = {
        card_number: card_number,
        mobile_phone: mobile_phone
      }

      response = @client.call(:execute, message: build_message('card_replace', parameters))
      parse_response(response.body)
    end

    private

    def build_message(contract_name, parameters)
      parameters = {
        'ServiceContractParameter' => parameters.to_a.map! do |k, v|
          { 'Name' => k.to_s, 'Value' => v }
        end
      }

      {
        'sessionId' => get_session,
        'contractName' => contract_name,
        'Parameters' => parameters
      }
    end

    def parse_response(response)
      body = response[:execute_response][:execute_result][:xml_value][:result]
      # TODO: проверка на ошибки
      body
    end

    def get_session
      '{00000000-0000-0000-0000-000000000000}'
    end
  end
end
