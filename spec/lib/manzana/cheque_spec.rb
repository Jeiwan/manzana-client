describe Manzana::Cheque do
  describe '#data' do
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
end
