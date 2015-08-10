describe Manzana::Cheque do
  describe '#data' do
    context 'when conditions are standard' do
      it 'returns prepared data' do
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
          summ_discounted: 300.0
        )

        expect(Manzana::Cheque.new(
          card_number: '12345',
          number: '12345',
          operation_type: 'Sale',
          summ: 123.45,
          discount: 0,
          summ_discounted: 0,
          paid_by_bonus: 0.0,
          items: [
            item1,
            item2
          ]
        ).data).to eq(
          'Card' => {
            'CardNumber' => '12345',
          },
          'Number' => '12345',
          'OperationType' => 'Sale',
          'Summ' => 123.45,
          'PaidByBonus' => 0.0,
          'Item' => [ item1.data, item2.data ]
        )
      end
    end

    context 'when cheque_reference is prodvided' do
      it 'returns ChequeReference as well' do
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
          summ_discounted: 300.0
        )
        cheque_reference = Manzana::ChequeReference.new(
          number: 123123,
          date_time: DateTime.new(2015, 8, 10, 8)
        )

        expect(Manzana::Cheque.new(
          card_number: '12345',
          number: '12345',
          operation_type: 'Return',
          summ: 123.45,
          discount: 0,
          summ_discounted: 0,
          paid_by_bonus: 0.0,
          cheque_reference: cheque_reference,
          items: [
            item1,
            item2
          ]
        ).data).to eq(
          'Card' => {
            'CardNumber' => '12345',
          },
          'Number' => '12345',
          'OperationType' => 'Return',
          'Summ' => 123.45,
          'PaidByBonus' => 0.0,
          'ChequeReference' => cheque_reference.data,
          'Item' => [ item1.data, item2.data ]
        )
      end
    end

    context 'when coupon is provided' do
      it 'returns Coupons as well' do
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
          summ_discounted: 300.0
        )

        expect(Manzana::Cheque.new(
          card_number: '12345',
          number: '12345',
          operation_type: 'Return',
          summ: 123.45,
          discount: 0,
          summ_discounted: 0,
          paid_by_bonus: 0.0,
          coupon: '123123123',
          items: [
            item1,
            item2
          ]
        ).data).to eq(
          'Card' => {
            'CardNumber' => '12345',
          },
          'Coupons' => {
            'Coupon' => {
              'Number' => '123123123'
            }
          },
          'Number' => '12345',
          'OperationType' => 'Return',
          'Summ' => 123.45,
          'PaidByBonus' => 0.0,
          'Item' => [ item1.data, item2.data ]
        )
      end
    end
  end
end
