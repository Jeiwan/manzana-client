require 'ostruct'

describe Manzana::LoyaltyService do
  subject do
    Manzana::LoyaltyService.new(
      wsdl: 'https://mbsdevweb13sp3.manzanagroup.ru:8088/POSProcessing.asmx?WSDL',
      basic_auth: false,
      organization: 'ilnepartner01',
      business_unit: 'ilneshop01',
      pos: 'ilnepos01',
      org_name: 'A5',
      logger: Logger.new(STDOUT)
    )
  end

  describe '#sale' do
    context 'when all parameters are correct' do
      it 'returns result' do
        VCR.use_cassette('sale/success_simple') do
          item1 = Manzana::Data::SaleChequeItem.new(
            article: 123,
            price: 100.0,
            quantity: 2,
            discount: 0
          )

          item2 = Manzana::Data::SaleChequeItem.new(
            article: 456,
            price: 333.0,
            quantity: 4,
            discount: 0
          )

          sale_cheque = Manzana::Data::SaleCheque.new(
            card_number: '201542',
            number: '7c2115f3-ef35-4be8-b7b5-92e51c509444',
            paid_by_bonus: 0.0,
            items: [item1, item2]
          )
          
          expect(subject.sale(sale_cheque: sale_cheque)).to include(
            active_charged_bonus: "45.96",
            available_payment: "0.00",
            card_active_balance: "45.96",
            card_balance: "45.96",
            card_discount: "0",
            card_number: "201542",
            card_quantity: "2",
            card_summ: "1532",
            charged_bonus: "45.96",
            discount: "0.000",
            item: [
              {
                position_number: "1",
                article: "123",
                price: "100.00",
                quantity: "2.000",
                summ: "200.00",
                discount: "0.000",
                summ_discounted: "200.00",
                available_payment: "0.00",
                writeoff_bonus: "0.00"
              },
              {
                position_number: "2",
                article: "456",
                price: "333.00",
                quantity: "4.000",
                summ: "1332.00",
                discount: "0.000",
                summ_discounted: "1332.00",
                available_payment: "0.00",
                writeoff_bonus: "0.00"
              }
            ],
            level_name: "Базовый 3%",
            message: "Начислено: 45,96",
            request_id: "1234",
            return_code: "0",
            summ: "1532.00",
            summ_discounted: "1532.00",
            writeoff_bonus: "0.00",
          )
        end
      end
    end

    context 'when receipt has no positions' do
      it 'returns successful result' do
        VCR.use_cassette('sale/no_positions') do
          sale_cheque = Manzana::Data::SaleCheque.new(
            card_number: '201542',
            number: '7c2115f3-ef35-4be8-b7b5-92e51c509444',
            paid_by_bonus: 0.0,
            items: []
          )
          
          expect(subject.sale(sale_cheque: sale_cheque)).to include(
            active_charged_bonus: "0.00",
            available_payment: "0.00",
            card_active_balance: "48.34",
            card_balance: "48.34",
            card_discount: "0",
            card_number: "201542",
            card_quantity: "5",
            card_summ: "1611.2",
            charged_bonus: "0.00",
            discount: "0.000",
            level_name: "Базовый 3%",
            message: "OK",
            request_id: "1234",
            return_code: "0",
            summ: "0.00",
            summ_discounted: "0.00",
            writeoff_bonus: "0.00",
          )
        end
      end
    end
  end

  describe '#return' do
    context 'when all parameters are correct' do
      it 'returns result' do
        VCR.use_cassette('return/success_simple') do
          item1 = Manzana::Data::SaleChequeItem.new(
            article: 123,
            price: 100.0,
            quantity: 2,
            discount: 0
          )

          item2 = Manzana::Data::SaleChequeItem.new(
            article: 456,
            price: 333.0,
            quantity: 4,
            discount: 0
          )

          sale_cheque = Manzana::Data::SaleCheque.new(
            card_number: '201542',
            number: '3df6df4b-f69f-4025-9548-954f56b54678',
            paid_by_bonus: 0.0,
            items: [item1, item2]
          )

          cheque_reference = Manzana::Data::ChequeReference.new(
            number: '7c2115f3-ef35-4be8-b7b5-92e51c509444',
            date_time: DateTime.iso8601('2015-08-24T07:21:52.163')
          )

          expect(subject.return(sale_cheque: sale_cheque, cheque_reference: cheque_reference)).to include(
            active_charged_bonus: "0.00",
            available_payment: "0.00",
            card_active_balance: "0",
            card_balance: "0",
            card_discount: "0",
            card_number: "201542",
            card_quantity: "2",
            card_summ: "0",
            discount: "0.000",
            item: [
              {
                position_number: "1",
                article: "123",
                price: "100.00",
                quantity: "2.000",
                summ: "200.00",
                discount: "0.000",
                summ_discounted: "200.00",
                available_payment: "0.00",
                writeoff_bonus: "0.00"
              },
              {
                position_number: "2",
                article: "456",
                price: "333.00",
                quantity: "4.000",
                summ: "1332.00",
                discount: "0.000",
                summ_discounted: "1332.00",
                available_payment: "0.00",
                writeoff_bonus: "0.00"
              }
            ],
            level_name: "Базовый 3%",
            message: "OK. Списано: 45,96",
            request_id: "1234",
            return_code: "0",
            summ: "1532.00",
            summ_discounted: "1532.00",
            writeoff_bonus: "45.96",
          )
        end
      end
    end
  end

  describe '#rollback' do
    context 'when all parameters are correct' do
      it 'returns result' do
        VCR.use_cassette('rollback/success_simple') do
          item1 = Manzana::Data::SaleChequeItem.new(
            article: 123,
            price: 100.0,
            quantity: 2,
            discount: 0
          )

          item2 = Manzana::Data::SaleChequeItem.new(
            article: 456,
            price: 333.0,
            quantity: 4,
            discount: 0
          )

          sale_cheque = Manzana::Data::SaleCheque.new(
            card_number: '201542',
            number: '4afd96ba-93d3-46ca-b02f-bff14f1b787a',
            paid_by_bonus: 0.0,
            items: [item1, item2]
          )

          transaction = subject.sale(sale_cheque: sale_cheque)[:transaction_id]

          expect(subject.rollback(card_number: '201542', transaction_id: transaction)).to include(
            active_charged_bonus: "0.00",
            available_payment: "0.00",
            card_active_balance: "45.96",
            card_balance: "45.96",
            card_discount: "0",
            card_number: "201542",
            card_quantity: "3",
            card_summ: "1532",
            charged_bonus: "0.00",
            discount: "0.000",
            level_name: "Базовый 3%",
            message: "OK",
            request_id: "1234",
            return_code: "0",
            summ: "0.00",
            summ_discounted: "0.00",
            writeoff_bonus: "0.00",
          )
        end
      end
    end
  end
end
