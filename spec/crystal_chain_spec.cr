require "./spec_helper"

describe CrystalChain do
  # TODO: Write tests
  describe "CrystalChain::Blockchain" do 
    it "is created" do
      object = create_test_chain
      object.should_not be_nil
    end
  end
  
end
