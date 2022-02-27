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

    it 'creates rows of CSV::Table object' do
      expect(@tr.rows).to be_a(CSV::Table)
    end

    it 'returns all instances of invoice items' do
      expect(@tr.all.count).to eq(4985)
      expect(@tr.all[0]).to be_a(Transaction)
    end

    it 'find invoice item by id' do
      expect(@tr.find_by_id(2)).to be_a(Transaction)
      expect(@tr.find_by_id(10).id).to eq(10)
    end

    it 'find all by invoice id' do
      expect(@tr.find_all_by_invoice_id(5)[0]).to be_a(Transaction)
    end

    it 'find all by credit card number' do
      expect(@tr.find_all_by_credit_card_number("4177816490204479")[0]).to be_a(Transaction)
      expect(@tr.find_all_by_credit_card_number("4177816490204479")[0].id).to eq(2)
    end

    it 'find all by result' do
      expect(@tr.find_all_by_result('success')[0]).to be_a(Transaction)
      expect(@tr.find_all_by_result('success')[0].id).to eq(1)
    end

  end

end
