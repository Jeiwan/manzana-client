require 'ostruct'

describe Manzana::Account do
  subject do
    Manzana::Account.new(
      wsdl: 'https://localhost?WSDL',
      basic_auth: false,
      organization: 'test',
      business_unit: 'test',
      pos: 'test',
      org_name: 'test'
    )
  end

  describe '#contact_registration' do
    context 'when all parameters are correct' do
      it 'returns result' do
        allow_any_instance_of(Savon::Client).to receive(:call).and_return(
          OpenStruct.new(
            body: {
              execute_response: {
                execute_result: {
                  xml_value: {
                    result: {
                      contact_id: 'c387f951-aa3e-e511-baa3-0012000000ff'
                    }
                  }
                }
              }
            }
          )
        )

        expect_any_instance_of(Savon::Client).to receive(:call).with(
          :execute,
          message: {
            'sessionId' => '{00000000-0000-0000-0000-000000000000}',
            'contractName' => 'contact_registration',
            'Parameters' => {
              'ServiceContractParameter' => [
                {
                  'Name' => 'mobile_phone',
                  'Value' => '+71234567890'
                },
                {
                  'Name' => 'card_number',
                  'Value' => '123123123'
                },
                {
                  'Name' => 'questionnaire_barcode',
                  'Value' => '321321321'
                }
              ]
            }
          }
        )

        expect(subject.contact_registration(
          card_number: '123123123',
          mobile_phone: '+71234567890',
          questionnaire_barcode: '321321321'
        )).to eq 'c387f951-aa3e-e511-baa3-0012000000ff'
      end
    end
  end
end
