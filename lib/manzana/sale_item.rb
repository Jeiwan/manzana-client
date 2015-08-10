module Manzana
  class SaleItem
    attr_accessor :data

    def initialize(article:, price:, quantity:, discount:)
      @data = {
        'Article' => article,
        'Price' => price,
        'Quantity' => quantity,
        'Discount' => discount
      }
    end
  end
end
