require "kemal"
require "./crystal_chain"
require "uuid"
require "json"
require "gzip"
require "flate"

  # Generate a globally unique address for this node
  node_identifier = UUID.random.to_s

  # Create our Blockchain
  blockchain = CrystalChain::Blockchain.new

  get "/" do 
    "CrystalChain"
  end

  get "/chain" do
    {chain: blockchain.chain}.to_json
  end

  get "/mine" do
    blockchain.mine
    "Block with index=#{blockchain.chain.last.index} is mined."
  end

  get "/pending" do
    {transactions: blockchain.uncommitted_transactions}.to_json
  end

  post "/transactions/new" do |env|

    transaction = CrystalChain::Block::Transaction.new(
      from: env.params.json["from"].as(String),
      to:  env.params.json["to"].as(String),
      amount:  env.params.json["amount"].as(Int64)

    )

    blockchain.add_transaction(transaction)

    "Transaction #{transaction} has been added to the node"
  end

  post "/nodes/register" do |env|
    nodes = env.params.json["nodes"].as(Array)
  
    raise "Empty array" if nodes.empty?
  
    nodes.each do |node|
      blockchain.register_node(node.to_s)
    end
  
    "New nodes have been added: #{blockchain.nodes}"
  end

  get "/nodes/resolve" do
    if blockchain.longest_chain
      "Successfully updated the chain"
    else
      "Current chain is up-to-date"
    end
  end

  Kemal.run

