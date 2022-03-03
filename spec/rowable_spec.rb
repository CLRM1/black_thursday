require_relative '../lib/rowable'
require_relative '../lib/merchant_repository'
require 'simplecov'
SimpleCov.start

RSpec.describe Rowable do
  describe "Iteration 1" do
    it "can read atttributes" do
      @merchant_repo = MerchantRepository.new('./data/mini_merchants.csv')
      expect(@merchant_repo.rows).to be_a(CSV::Table)
    end
  end
end
