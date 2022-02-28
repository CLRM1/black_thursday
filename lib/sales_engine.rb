require_relative '../lib/item'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/sales_analyst'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'
require_relative '../lib/customer'
require_relative '../lib/customer_repository'
require_relative '../lib/transaction'
require_relative '../lib/transaction_repository'
require_relative '../lib/invoice_item'
require_relative '../lib/invoice_item_repository'

require 'CSV'

class SalesEngine

  attr_reader :items,
              :merchants,
              :invoices,
              :customers,
              :transactions,
              :invoice_items

  def initialize(data_hash)
    @items = ItemRepository.new(data_hash[:items])
    @merchants = MerchantRepository.new(data_hash[:merchants])
    @invoices = InvoiceRepository.new(data_hash[:invoices])
    @customers = CustomerRepository.new(data_hash[:customers])
    @transactions = TransactionRepository.new(data_hash[:transactions])
    @invoice_items = InvoiceItemRepository.new(data_hash[:invoice_items])
  end

  def self.from_csv(data_hash)
    SalesEngine.new(data_hash)
  end

  def analyst
    SalesAnalyst.new(@merchants, @items, @invoices, @customers, @transactions, @invoice_items)
  end
end
