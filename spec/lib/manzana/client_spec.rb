require 'ostruct'

describe Manzana::Client do
  subject do
    Manzana::Client.new(
      wsdl: 'https://localhost?WSDL',
      basic_auth: false,
      organization: 'test',
      business_unit: 'test',
      pos: 'test',
      org_name: 'test'
    )
  end

  describe '#balance_request' do
    context 'when card number is incorrect' do
      it 'raises an error' do
        allow_any_instance_of(Savon::Client).to receive(:call).and_return(
          OpenStruct.new(body: {
            process_request_response: {
              process_request_result: {
                balance_response: {
                  transaction_id: '123123123',
                  request_id: '123123123',
                  processed: DateTime.now.iso8601,
                  return_code: 31337,
                  message: 'Неверный номер карты'
                }
              }
            }
          })
        )

        expect{ subject.balance_request(card_number: '31337') }.to raise_error Manzana::Exceptions::RequestError
      end
    end

    context 'when everything is fine' do
      it "returns card's balance" do
        processed = DateTime.now.iso8601
        allow_any_instance_of(Savon::Client).to receive(:call).and_return(
          OpenStruct.new(body: {
            process_request_response: {
              process_request_result: {
                balance_response: {
                  transaction_id: '123123123',
                  request_id: '123123123',
                  processed: processed,
                  return_code: 0,
                  card_balance: 100,
                  card_activeBalance: 100,
                  card_summ: 10000,
                  card_summ_discounted: 10000,
                  card_discount: 0
                }
              }
            }
          })
        )

        expect(subject.balance_request(card_number: '12345')).to eq(
          transaction_id: '123123123',
          request_id: '123123123',
          processed: processed,
          return_code: 0,
          card_balance: 100,
          card_activeBalance: 100,
          card_summ: 10000,
          card_summ_discounted: 10000,
          card_discount: 0
        )
      end
    end
  end

  describe '#cheque_request' do
    it 'returns result' do
      item1 = Manzana::ChequeItem.new(
        position_number: 1,
        article: 1234,
        price: 123.0,
        quantity: 2,
        summ: 246.0,
        discount: 0.0,
        summ_discounted: 246.0
      )
      item2 = Manzana::ChequeItem.new(
        position_number: 2,
        article: 4321,
        price: 100.0,
        quantity: 3,
        summ: 300.0,
        discount: 10.0,
        summ_discounted: 270.0
      )
      cheque = Manzana::Cheque.new(
        card_number: '12345',
        number: '12345',
        operation_type: 'Sale',
        summ: 546.0,
        discount: 0.05,
        summ_discounted: 516.0,
        paid_by_bonus: 0.0,
        items: [
          item1,
          item2
        ]
      )

      response = {
        card_balance: 516.0,
        card_activeBalance: 516.0,
        card_summ: 546.0,
        card_summDiscounted: 516.0,
        card_discount: 0.0,
        summ: 546.0,
        discount: 0.0,
        summ_discounted: 546.0,
        charged_bonus: 516.0,
        items: [
          {
            position_number: 1,
            article: 1234,
            price: 123.0,
            quantity: 2,
            summ: 246.0,
            discount: 0.0,
            summ_discounted: 246.0,
            available_payment: 0.0
          },
          {
            position_number: 2,
            article: 4321,
            price: 100.0,
            quantity: 3,
            summ: 300.0,
            discount: 10.0,
            summ_discounted: 270.0,
            available_payment: 0.0
          }
        ]
      }

      allow(subject).to receive(:cheque_request).and_return(response)

      expect(subject.cheque_request(type: 'Soft', cheque: cheque)).to eq(response)
    end
  end
end
