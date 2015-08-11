describe Manzana::Data::ChequeReference do
  describe '#data' do
    it 'returns prepared data' do
      expect(Manzana::Data::ChequeReference.new(
        number: '1234',
        date_time: DateTime.new(2015, 8, 10, 8)
      ).data).to eq(
        'Number' => '1234',
        'DateTime' => DateTime.new(2015, 8, 10, 8).iso8601
      )
    end
  end
end
