require_relative '../lib/transaction'
require 'time'
require 'CSV'
require 'simplecov'
SimpleCov.start

RSpec.describe Transaction do

  describe 'create a transaction class' do
    t = Transaction.new({
      :id => 6,
      :invoice_id => 8,
      :credit_card_number => "4242424242424242",
      :credit_card_expiration_date => "0220",
      :result => "success",
      :created_at => Time.now,
      :updated_at => Time.now
    })

    it 'exists' do
      expect(t).to be_a(Transaction)
    end

    it 'can read transaction attributes' do
      expect(t.id).to eq(6)
      expect(t.invoice_id).to eq(8)
      expect(t.credit_card_number).to eq("4242424242424242")
      expect(t.credit_card_expiration_date).to eq("0220")
      expect(t.result).to eq(:success)
      expect(t.created_at).to be_a(Time)
      expect(t.updated_at).to be_a(Time)
    end
  end

end
