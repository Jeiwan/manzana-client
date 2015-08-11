module Manzana
  module Data
    class SaleCheque
      attr_accessor :data

      def initialize(card_number:, number:, paid_by_bonus:, items:)
        @data = {
          'Card' => {
            'CardNumber' => card_number
          },
          'Number' => number,
          'PaidByBonus' => paid_by_bonus,
          'Item' => items.map(&:data)
        }
      end
    end
  end
end
