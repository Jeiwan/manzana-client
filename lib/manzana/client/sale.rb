module Manzana
  class Client
    module Sale
      def sale(sale_cheque:)
        @cheque = sale_cheque.data
        prepare_sale

        cheque_request(type: 'Soft', cheque: @cheque)
        cheque_request(type: 'Fiscal', cheque: @cheque)
      end

      private

      def prepare_sale
        prepare_items
        @cheque['OperationType'] = 'Sale'
        @cheque['Summ'] = @cheque['Item'].map { |item| item['Summ'].to_f }.inject(:+)
        @cheque['SummDiscounted'] = @cheque['Item'].map { |item| item['SummDiscounted'].to_f }.inject(:+)
        @cheque['Discount'] = ((1 - @cheque['SummDiscounted'] / @cheque['Summ']) * 100).round(2)
      end

      def prepare_items
        @cheque['Item'].each.with_index do |item, index|
          item['Summ'] = item['Price'].to_f * item['Quantity'].to_f
          discounted = item['Price'].to_f * (1 - (item['Discount'].to_f / 100))
          item['SummDiscounted'] = item['Quantity'].to_f * discounted
          item['PositionNumber'] = index + 1
        end
      end
    end
  end
end
