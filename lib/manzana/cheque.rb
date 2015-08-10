module Manzana
  class Cheque
    attr_accessor :data

    def initialize(card_number:, number:, operation_type:, summ:, discount:, summ_discounted:, paid_by_bonus:, items:)
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
    end
  end
end
