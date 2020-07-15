require "./block"
require "./transaction"
require "./consensus"
require "json"

module CrystalChain
  class Blockchain
    include JSON::Serializable
    include Consensus
    getter chain, uncommitted_transactions, nodes

    BLOCK_SIZE = 25

    def initialize
      @chain = [ Block.first ]
      @uncommitted_transactions = [] of Block::Transaction
      @nodes = Set(String).new [] of String
    end

    def add_transaction(transaction)
      @uncommitted_transactions << transaction
    end

    def mine
      raise "No transactions to be mined" if @uncommitted_transactions.empty?

      new_block = Block.next(
        previous_block: @chain.last,
        transactions: @uncommitted_transactions.shift(BLOCK_SIZE)
      )

      @chain << new_block
   end


  end
end
