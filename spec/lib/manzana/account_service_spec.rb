require 'ostruct'

describe Manzana::AccountService do
  subject do
    Manzana::AccountService.new(
      wsdl: 'http://mbsdevweb13sp3.manzanagroup.ru:8188/PrivateOfficeDataService.asmx?WSDL',
      organization: 'ilnepartner01',
      business_unit: 'ilneshop01',
      pos: 'ilnepos01',
      org_name: 'A5',
      logger: Logger.new(STDOUT)
    )
  end

  describe '#contact_registration' do
    context 'when all parameters are correct' do
      it 'returns result without errors' do
        VCR.use_cassette('contact_registration/success') do
          expect(subject.contact_registration(
            card_number: '201541',
            mobile_phone: '+71234567890',
            questionnaire_barcode: '321321321'
          )).to eq(code: '0', result: { contact_id: '92520229-db47-e511-80df-00155dfa8014' })
        end
      end
    end

    context 'when some parameters are incorrect' do
      it 'returns error' do
        VCR.use_cassette('contact_registration/fail') do
          expect(subject.contact_registration(
            card_number: '31337',
            mobile_phone: '+71234567890',
            questionnaire_barcode: '321321321'
          )).to eq(code: '110051', message: 'Карта не может быть использована для регистрации конткта.')
        end
      end
    end
  end

  describe '#complete_registration' do
    context 'when all parameters are correct' do
      it 'returns true' do
        VCR.use_cassette('complete_registration/success') do
          expect(subject.complete_registration(
            contact_id: '92520229-db47-e511-80df-00155dfa8014',
            temp_code: '61868054'
          )).to eq(code: '0', result: true)
        end
      end
    end

    context 'when some parameters are incorrect' do
      it 'returns error' do
        VCR.use_cassette('complete_registration/fail') do
          expect(subject.complete_registration(
            contact_id: '92520229-db47-e511-80df-00155dfa8014',
            temp_code: '61868054'
          )).to eq(code: '110043', message: 'Временный код не найден.')
        end
      end
    end
  end

  describe '#registration_code_send' do
    context 'when all parameters are correct' do
      it 'returns result' do
        VCR.use_cassette('registration_code_send/success') do
          contact_id = subject.contact_registration(
            card_number: '201542',
            mobile_phone: '+71231231231',
            questionnaire_barcode: '123123123'
          )[:result][:contact_id]

          expect(subject.registration_code_send(
            contact_id: contact_id
          )).to eq(code: '0', result: true)
        end
      end
    end

    context 'when some parameters are wrong' do
      it 'returns error' do
        VCR.use_cassette('registration_code_send/fail') do
          expect(subject.registration_code_send(
            contact_id: '7a3294f9-e447-e511-80df-00155dfa8014'
          )).to eq(code: '100940', message: 'не удалось отправить пароль')
        end
      end
    end
  end

  describe '#rollback_registration' do
    context 'when all parameters are correct' do
      it 'returns result' do
        VCR.use_cassette('rollback_registration/success') do
          expect(subject.rollback_registration(
            contact_id: '7a3294f9-e447-e511-80df-00155dfa8014'
          )).to eq(code: '0', result: true)
        end
      end
    end

    context 'when some parameters are wrong' do
      it 'returns error' do
        VCR.use_cassette('rollback_registration/fail') do
          expect(subject.rollback_registration(
            contact_id: 'c72514ca-e447-e511-80df-00155dfa8014'
          )).to eq(code: '110055', message: 'Регистрацию этого контакта нельзя отменить: у контакта более одной карты.')
        end
      end
    end
  end

  describe '#card_replace' do
    context 'when all parameters are correct' do
      it 'returns result' do
        VCR.use_cassette('card_replace/success') do
          expect(subject.card_replace(
            card_number: '201542',
            mobile_phone: '+71234567890'
          )).to eq(code: '0', result: true)
        end
      end
    end

    context 'when some parameters are wrong' do
      it 'returns error' do
        VCR.use_cassette('card_replace/fail') do
          expect(subject.card_replace(
            card_number: '201542',
            mobile_phone: '+71234567890'
          )).to eq(code: '110051', message: 'Карта не может быть использована для замены.')
        end
      end
    end
  end
end
