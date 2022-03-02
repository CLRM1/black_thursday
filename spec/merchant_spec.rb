require_relative '../lib/merchant'
require 'simplecov'
SimpleCov.start

RSpec.describe Merchant do
  describe "Iteration 1" do
    it "exits" do
      m = Merchant.new({:id => 5, :name => "Turing School", :created_at => "2009-12-07"})
      expect(m).to be_an_instance_of(Merchant)
    end

    it "has an id" do
      m = Merchant.new({:id => 5, :name => "Turing School", :created_at => "2009-12-07"})
      expect(m.id).to eq(5)
    end

    it "has a name" do
      m = Merchant.new({:id => 5, :name => "Turing School", :created_at => "2009-12-07"})
      expect(m.name).to eq("Turing School")
    end

    it 'is initialized with a created_at date' do
      m = Merchant.new({:id => 5, :name => "Turing School", :created_at => "2009-12-07"})
      expect(m.created_at).to be_a(Time)
    end
  end

end
