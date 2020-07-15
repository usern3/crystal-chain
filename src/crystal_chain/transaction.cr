require "json"

module CrystalChain
  class Block
    class Transaction
      include JSON::Serializable

      property from : String
      property to : String
      property amount : Int64

      def initialize(@from, @to, @amount)
      end
    end
  end
end