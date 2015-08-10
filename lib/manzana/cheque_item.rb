module Manzana
  class ChequeItem
    attr_accessor :data

    def initialize(position_number:, article:, price:, quantity:, summ:, discount:, summ_discounted:)
      @data = {
        'PositionNumber' => position_number,
        'Article' => article,
        'Price' => price,
        'Quantity' => quantity,
        'Summ' => summ,
        'Discount' => discount,
        'SummDiscounted' => summ_discounted
      }
    end
  end
end
