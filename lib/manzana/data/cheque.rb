module Manzana
  module Data
    class Cheque
      attr_accessor :data

      def initialize(card_number:, number:, operation_type:, summ:, discount:, summ_discounted:, paid_by_bonus:, items:,
                    cheque_reference: nil, coupon: nil)
        @data = {
          'Card' => {
            'CardNumber' => card_number
          },
          'Number' => number,
          'OperationType' => operation_type,
          'Summ' => summ,
          'PaidByBonus' => paid_by_bonus,
          'Item' => items.map(&:data)
        }

        @data['ChequeReference'] = cheque_reference.data if cheque_reference
        @data['Coupons'] = { 'Coupon' => { 'Number' => coupon } } if coupon
      end
    end
  end
end
