require_relative '../lib/transaction'
require 'bigdecimal'
require 'CSV'
require 'time'


class TransactionRepository

  attr_reader :filename, :transactions

  def initialize(filename)
    @filename = filename
    @transactions = self.all
  end

  def rows
    rows = CSV.read(@filename, headers: true, header_converters: :symbol)
  end

  def all
    rows.map {|row| Transaction.new(row)}
  end

  def find_by_id(id)
    @transactions.find {|transaction| transaction.id == id}
  end

  def find_all_by_invoice_id(invoice_id)
    @transactions.find_all {|transaction| transaction.invoice_id == invoice_id}
  end

  def find_all_by_credit_card_number(credit_card_number)
    @transactions.find_all {|transaction| transaction.credit_card_number == credit_card_number}
  end

  def find_all_by_result(result)
    @transactions.find_all {|transaction| transaction.result == result.to_sym}
  end

  def current_highest_id
    sorted = @transactions.sort_by {|transaction| transaction.id}
    highest_id = sorted[-1].id
  end

  def create(attributes)
    new_id = current_highest_id + 1
    attributes[:id] = new_id
    @transactions << new_transaction = Transaction.new(attributes)
    new_transaction
  end

  def update(id, attributes)
    if updated_transaction = find_by_id(id)
      updated_transaction.credit_card_number = attributes[:credit_card_number] if attributes[:credit_card_number]
      updated_transaction.credit_card_expiration_date = attributes[:credit_card_expiration_date] if attributes[:credit_card_expiration_date]
      updated_transaction.result = attributes[:result] if attributes[:result]
      updated_transaction.updated_at = Time.now
    end
  end

  def delete(id)
    deleted_transaction = find_by_id(id)
    @transactions.delete(deleted_transaction)
  end

  def all_successful_transactions
    @transactions.map do |transaction|
      if transaction.result == :success
        transaction.invoice_id
      end
    end.compact

  end

  def inspect
   "#<#{self.class} #{@merchants.size} rows>"
  end

end
