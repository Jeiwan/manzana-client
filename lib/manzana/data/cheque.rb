module Manzana
  module Data
    class Cheque
      attr_accessor :data

      def initialize(card_number:, number:, operation_type:, summ:, discount:, summ_discounted:, paid_by_bonus:, items:,
                    return_receipt_number: nil, coupon: nil)
        @data = {
          'Card' => {
            'CardNumber' => card_number
          },
          'Number' => number,
          'OperationType' => operation_type,
          'Summ' => summ,
          'Discount' => discount.to_f.round(3),
          'SummDiscounted' => summ_discounted,
          'PaidByBonus' => paid_by_bonus,
          'Item' => items.map(&:data)
        }

        @data['ChequeReference'] = { 'Number' => return_receipt_number } if return_receipt_number
        @data['Coupons'] = { 'Coupon' => { 'Number' => coupon } } if coupon
      end
    end
  end
end
