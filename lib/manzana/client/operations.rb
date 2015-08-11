module Manzana
  class Client
    module Operations
      def sale(sale_cheque:)
        @cheque = sale_cheque.data
        prepare_sale

        perform_operation
      end

      def return(sale_cheque:, cheque_reference:)
        @cheque = sale_cheque.data
        @cheque['ChequeReference'] = cheque_reference.data
        prepare_return

        perform_operation
      end

      def rollback(card_number:, transaction_id:)
        @cheque = {}
        @cheque['Card'] = { 'CardNumber' => card_number }
        @cheque['TransactionReference'] = { 'TransactionID' => transaction_id }
        @cheque['OperationType'] = 'Rollback'

        perform_operation
      end

      private

      def prepare_sale
        prepare_items
        prepare_receipt_sums
        @cheque['OperationType'] = 'Sale'
      end

      def prepare_return
        prepare_items
        prepare_receipt_sums
        @cheque['OperationType'] = 'Return'
      end

      def prepare_items
        @cheque['Item'].each.with_index do |item, index|
          item['Summ'] = item['Price'].to_f * item['Quantity'].to_f
          discounted = item['Price'].to_f * (1 - (item['Discount'].to_f / 100))
          item['SummDiscounted'] = item['Quantity'].to_f * discounted
          item['PositionNumber'] = index + 1
        end
      end

      def prepare_receipt_sums
        @cheque['Summ'] = @cheque['Item'].map { |item| item['Summ'].to_f }.inject(:+)
        @cheque['SummDiscounted'] = @cheque['Item'].map { |item| item['SummDiscounted'].to_f }.inject(:+)
        @cheque['Discount'] = ((1 - @cheque['SummDiscounted'] / @cheque['Summ']) * 100).round(2)
      end

      def perform_operation
        cheque_request(type: 'Soft', cheque: @cheque)
        cheque_request(type: 'Fiscal', cheque: @cheque)
      end
    end
  end
end
