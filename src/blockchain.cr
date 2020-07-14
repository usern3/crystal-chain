require "./block"
require "./transaction"

module CrystalChain
  class Blockchain
    getter chain
    getter uncommitted_transactions

    def initialize
      @chain = [ Block.first ]
      @uncommitted_transactions = [] of Block::Transaction
    end

    def add_transaction(transaction)
      @uncommitted_transactions << transaction
    end
  end
end
