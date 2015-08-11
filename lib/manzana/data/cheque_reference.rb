module Manzana
  module Data
    class ChequeReference
      attr_accessor :data

      def initialize(number:, date_time:)
        @data = {
          'Number' => number,
          'DateTime' => date_time.iso8601
        }
      end
    end
  end
end
