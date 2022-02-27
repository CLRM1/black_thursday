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
  end

end
