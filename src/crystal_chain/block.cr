require "openssl"
require "./proof_of_work"
require "./transaction"
require "json"

module CrystalChain
  class Block
    include ProofOfWork
    include JSON::Serializable
    property current_hash : String, index : Int32, nonce : Int32, previous_hash : String

    def initialize(index = 0, data = "data", transactions = [] of Transaction, previous_hash = "hash")
      @data = data
      @index = index
      @timestamp = Time.utc
      @previous_hash = previous_hash
      @nonce = proof_of_work
      @current_hash = calc_hash_with_nonce(@nonce)
      @transactions = transactions
    end

    def self.first(data = "Genesis Block")
      Block.new(data: data, previous_hash: "0")
    end

    def self.next(previous_block, transactions = [] of Transaction)
      Block.new(
        transactions: transactions,
        index: previous_block.index + 1,
        previous_hash: previous_block.current_hash
      )
    end

    private def hash_block
      hash = OpenSSL::Digest.new("SHA256")
      hash.update("#{@index}#{@timestamp}#{@data}#{@previous_hash}")
      hash.final.hexstring
    end
    
    def recalculate_hash
      @nonce = proof_of_work
      @current_hash = calc_hash_with_nonce(@nonce)
    end
  
  end
end