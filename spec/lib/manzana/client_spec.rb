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
    it "returns card's balance" do
      allow(subject).to receive(:balance_request).and_return(cardBalance: 100)

      expect(subject.balance_request('12345')).to eq(cardBalance: 100)
    end
  end
end
