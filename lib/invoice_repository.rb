require_relative '../lib/item'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require_relative '../lib/invoice'
require 'CSV'

class InvoiceRepository
  attr_reader :filename, :invoices

  def initialize(filename)
    @filename = filename
    @invoices = self.all
  end

  def rows
    rows = CSV.read(@filename, headers: true, header_converters: :symbol)
  end

  def all
    result = rows.map {|row| Invoice.new(row)}
  end

  def find_by_id(id)
    @invoices.find do |invoice|
      if invoice.id == id
        invoice
      end
    end
  end


end
