require_relative '../lib/item'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require_relative '../lib/invoice_item'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/transaction'
require_relative '../lib/transaction_repository'
require 'CSV'
require 'simplecov'
SimpleCov.start

RSpec.describe TransactionRepository do

  describe 'create a transaction' do

    before(:each) do
      @tr = TransactionRepository.new('./data/transactions.csv')
    end

    it 'exists' do
      expect(@tr).to be_a(TransactionRepository)
    end

  end

end
