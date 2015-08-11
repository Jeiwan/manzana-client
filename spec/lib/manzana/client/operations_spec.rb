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

  describe '#sale' do
    context 'when all parameters are correct' do
      it 'returns result' do
        item1 = Manzana::Data::SaleChequeItem.new(
          article: 123,
          price: 100.0,
          quantity: 2,
          discount: 0
        )

        item2 = Manzana::Data::SaleChequeItem.new(
          article: 31337,
          price: 100.0,
          quantity: 4,
          discount: 10
        )

        sale_cheque = Manzana::Data::SaleCheque.new(
          card_number: 31337,
          number: '123123123',
          paid_by_bonus: 0.0,
          items: [item1, item2]
        )
        
        message_body = {
          request: {
            'ChequeRequest' => {
              'Card' => sale_cheque.data['Card'],
              'PaidByBonus' => 0.0,
              'Number' => sale_cheque.data['Number'],
              'RequestID' => 1234,
              'DateTime' => DateTime.now.iso8601,
              'Organization' => 'test',
              'BusinessUnit' => 'test',
              'POS' => 'test',
              'OperationType' => 'Sale',
              'Summ' => 600.0,
              'Discount' => 6.67,
              'SummDiscounted' => 560.0,
              'Item' => [
                {
                  'PositionNumber' => 1,
                  'Article' => item1.data['Article'],
                  'Price' => item1.data['Price'],
                  'Quantity' => item1.data['Quantity'],
                  'Summ' => 200.0,
                  'Discount' => 0,
                  'SummDiscounted' => 200.0
                },
                {
                  'PositionNumber' => 2,
                  'Article' => item2.data['Article'],
                  'Price' => item2.data['Price'],
                  'Quantity' => item2.data['Quantity'],
                  'Summ' => 400.0,
                  'Discount' => 10,
                  'SummDiscounted' => 360.0
                }
              ],
              '@ChequeType' => 'Soft'
            }
          },
          'orgName' => 'test'
        }

        response_body = {
          transaction_id: '123123123',
          request_id: '123123123',
          processed: DateTime.now.iso8601,
          return_code: 0,
          message: 'OK',
          available_payment: 0.0,
          card_balance: 100.0,
          card_active_balance: 100.0,
          card_summ: 10000,
          card_summ_discunted: 10000,
          card_discount: 0.0,
          summ: 600,
          discount: 6.67,
          summ_discounted: 560,
          charged_bonus: 560,
          active_charged_bonus: 560,
          item: [
            {
              position_number: 1,
              article: item1.data['Article'],
              price: item1.data['Price'],
              quantity: item1.data['Quantity'],
              summ: 200.0,
              discount: 0,
              summ_discounted: 200.0
            },
            {
              position_number: 2,
              article: item2.data['Article'],
              price: item2.data['Price'],
              quantity: item2.data['Quantity'],
              summ: 400.0,
              discount: 10,
              summ_discounted: 360.0
            }
          ]
        }

        allow_any_instance_of(Savon::Client).to receive(:call).and_return(
          OpenStruct.new(
            body: {
              process_request_response: {
                process_request_result: {
                  cheque_response: response_body
                }
              }
            }
          )
        )
        expect_any_instance_of(Savon::Client).to receive(:call).with(
          :process_request,
          message: message_body
        )

        expect(subject.sale(sale_cheque: sale_cheque)).to eq response_body
      end
    end
  end

  describe '#return' do
    context 'when all parameters are correct' do
      it 'returns result' do
        item1 = Manzana::Data::SaleChequeItem.new(
          article: 123,
          price: 100.0,
          quantity: 2,
          discount: 0
        )

        item2 = Manzana::Data::SaleChequeItem.new(
          article: 31337,
          price: 100.0,
          quantity: 4,
          discount: 10
        )

        sale_cheque = Manzana::Data::SaleCheque.new(
          card_number: 31337,
          number: '1234567890',
          paid_by_bonus: 0.0,
          items: [item1, item2]
        )

        cheque_reference = Manzana::Data::ChequeReference.new(
          number: '123123123',
          date_time: DateTime.new(2015, 8, 11, 8)
        )
        
        message_body = {
          request: {
            'ChequeRequest' => {
              'Card' => sale_cheque.data['Card'],
              'PaidByBonus' => 0.0,
              'Number' => sale_cheque.data['Number'],
              'RequestID' => 1234,
              'DateTime' => DateTime.now.iso8601,
              'Organization' => 'test',
              'BusinessUnit' => 'test',
              'POS' => 'test',
              'OperationType' => 'Return',
              'Summ' => 600.0,
              'Discount' => 6.67,
              'SummDiscounted' => 560.0,
              'ChequeReference' => {
                'Number' => '123123123',
                'DateTime' => DateTime.new(2015, 8, 11, 8).iso8601,
                'Organization' => 'test',
                'BusinessUnit' => 'test',
                'POS' => 'test'
              },
              'Item' => [
                {
                  'PositionNumber' => 1,
                  'Article' => item1.data['Article'],
                  'Price' => item1.data['Price'],
                  'Quantity' => item1.data['Quantity'],
                  'Summ' => 200.0,
                  'Discount' => 0,
                  'SummDiscounted' => 200.0
                },
                {
                  'PositionNumber' => 2,
                  'Article' => item2.data['Article'],
                  'Price' => item2.data['Price'],
                  'Quantity' => item2.data['Quantity'],
                  'Summ' => 400.0,
                  'Discount' => 10,
                  'SummDiscounted' => 360.0
                }
              ],
              '@ChequeType' => 'Soft'
            }
          },
          'orgName' => 'test'
        }

        response_body = {
          transaction_id: '123123123',
          request_id: '123123123',
          processed: DateTime.now.iso8601,
          return_code: 0,
          message: 'OK',
          available_payment: 0.0,
          card_balance: 100.0,
          card_active_balance: 100.0,
          card_summ: 10000,
          card_summ_discunted: 10000,
          card_discount: 0.0,
          summ: 600,
          discount: 6.67,
          summ_discounted: 560,
          charged_bonus: 560,
          active_charged_bonus: 560,
          item: [
            {
              position_number: 1,
              article: item1.data['Article'],
              price: item1.data['Price'],
              quantity: item1.data['Quantity'],
              summ: 200.0,
              discount: 0,
              summ_discounted: 200.0
            },
            {
              position_number: 2,
              article: item2.data['Article'],
              price: item2.data['Price'],
              quantity: item2.data['Quantity'],
              summ: 400.0,
              discount: 10,
              summ_discounted: 360.0
            }
          ]
        }

        allow_any_instance_of(Savon::Client).to receive(:call).and_return(
          OpenStruct.new(
            body: {
              process_request_response: {
                process_request_result: {
                  cheque_response: response_body
                }
              }
            }
          )
        )
        expect_any_instance_of(Savon::Client).to receive(:call).with(
          :process_request,
          message: message_body
        )

        expect(subject.return(sale_cheque: sale_cheque, cheque_reference: cheque_reference)).to eq response_body
      end
    end
  end

  describe '#rollback' do
    context 'when all parameters are correct' do
      it 'returns result' do
        message_body = {
          request: {
            'ChequeRequest' => {
              'Card' => {
                'CardNumber' => '123123123'
              },
              'RequestID' => 1234,
              'DateTime' => DateTime.now.iso8601,
              'Organization' => 'test',
              'BusinessUnit' => 'test',
              'POS' => 'test',
              'OperationType' => 'Rollback',
              'TransactionReference' => {
                'TransactionID' => '321321321'
              },
              '@ChequeType' => 'Soft'
            }
          },
          'orgName' => 'test'
        }

        response_body = {
          transaction_id: '123123123',
          request_id: '123123123',
          processed: DateTime.now.iso8601,
          return_code: 0,
          message: 'OK',
          card_balance: 100.0,
          card_active_balance: 100.0,
          card_summ: 10000,
          card_summ_discunted: 10000,
          card_discount: 0.0,
          charged_bonus: 0,
          active_charged_bonus: 0
        }

        allow_any_instance_of(Savon::Client).to receive(:call).and_return(
          OpenStruct.new(
            body: {
              process_request_response: {
                process_request_result: {
                  cheque_response: response_body
                }
              }
            }
          )
        )
        expect_any_instance_of(Savon::Client).to receive(:call).with(
          :process_request,
          message: message_body
        )

        expect(subject.rollback(card_number: '123123123', transaction_id: '321321321')).to eq response_body
      end
    end
  end
end
