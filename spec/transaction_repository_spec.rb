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
      expect(@tr.find_all_by_invoice_id(2179)[0]).to be_a(Transaction)
      expect(@tr.find_all_by_invoice_id(2179).count).to eq(2)
    end

    it 'find all by credit card number' do
      expect(@tr.find_all_by_credit_card_number("4177816490204479")[0]).to be_a(Transaction)
      expect(@tr.find_all_by_credit_card_number("4177816490204479")[0].id).to eq(2)
    end

    it 'find all by result' do
      expect(@tr.find_all_by_result('success')[0]).to be_a(Transaction)
      expect(@tr.find_all_by_result('success')[0].id).to eq(1)
    end

    it 'finds the current highest id' do
      expect(@tr.current_highest_id).to eq(4985)
    end

    it 'create new transaction' do
      t = {
        :invoice_id => 8,
        :credit_card_number => "4242424242424242",
        :credit_card_expiration_date => "0220",
        :result => "success",
        :created_at => Time.now,
        :updated_at => Time.now
      }
      @tr.create(t)
      expect(@tr.find_by_id(4986)).to be_a(Transaction)
      expect(@tr.find_by_id(4986).credit_card_expiration_date).to eq("0220")
    end

    it 'updates credit card number, expiration, result and updated at time' do
      original_time = @tr.find_by_id(4985).updated_at
      attributes = {credit_card_number: "4040404040404040", credit_card_expiration_date: "0522", result: 'failed'}
      @tr.update(4985, attributes)
      expect(@tr.find_by_id(4985).updated_at).to be > original_time
      expect(@tr.find_by_id(4985).credit_card_number).to eq("4040404040404040")
      expect(@tr.find_by_id(4985).credit_card_expiration_date).to eq("0522")
      expect(@tr.find_by_id(4985).result).to eq("failed")
    end

    it 'can delete invoice item by id' do
      t = {
        :invoice_id => 8,
        :credit_card_number => "4242424242424242",
        :credit_card_expiration_date => "0220",
        :result => "success",
        :created_at => Time.now,
        :updated_at => Time.now
      }
      @tr.create(t)
      @tr.delete(4986)
      expect(@tr.find_by_id(4986)).to eq(nil)
    end

    it 'can give all successful transactions' do
      expect(@tr.all_successful_transactions.count).to eq(4158)
    end

  

  end

end
