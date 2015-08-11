module Manzana
  module Data
    class SaleCheque
      attr_accessor :data

      def initialize(card_number:, number:, paid_by_bonus:, items:, coupon: nil)
        @data = {
          'Card' => {
            'CardNumber' => card_number
          },
          'Number' => number,
          'PaidByBonus' => paid_by_bonus,
          'Item' => items.map(&:data)
        }

        @data['Coupons'] = { 'Coupon' => { 'Number' => coupon } } if coupon
      end
    end
  end
end
