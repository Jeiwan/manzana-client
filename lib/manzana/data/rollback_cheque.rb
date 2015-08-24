module Manzana
  module Data
    class RollbackCheque
      attr_accessor :data

      def initialize(card_number:, transaction_id:)
        @data = {
          'Card' => {
            'CardNumber' => card_number
          },
          'TransactionReference' => {
            'TransactionID' => transaction_id
          },
          'OperationType' => 'Rollback'
        }
      end
    end
  end
end
