describe Manzana::Sale do
  describe '#data' do
    it 'returns prepared data' do
      expect(Manzana::SaleItem.new(
        article: 123,
        price: 100.0,
        quantity: 2,
        discount: 0
      ).data).to eq(
        'Article' => 123,
        'Price' => 100.0,
        'Quantity' => 2,
        'Discount' => 0
      )
    end
  end
end
