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

  def find_all_by_invoice_id(id)
    @transactions.find_all {|transaction| transaction.id == id}
  end


end
