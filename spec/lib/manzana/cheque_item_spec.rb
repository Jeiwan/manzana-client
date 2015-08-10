describe Manzana::ChequeItem do
  describe '#data' do
    it 'returns prepared data' do
      expect(Manzana::ChequeItem.new(
        position_number: 1,
        article: 1234,
        price: 123.0,
        quantity: 2,
        summ: 246.0,
        discount: 0.0,
        summ_discounted: 246.0
      ).data).to eq(
        'PositionNumber' => 1,
        'Article' => 1234,
        'Price' => 123.0,
        'Quantity' => 2,
        'Summ' => 246.0,
        'Discount' => 0.0,
        'SummDiscounted' => 246.0
      )
    end
  end
end
