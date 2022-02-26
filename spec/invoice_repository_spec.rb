require_relative '../lib/item'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'
require 'CSV'
require 'simplecov'
require 'bigdecimal'

SimpleCov.start

RSpec.describe InvoiceRepository do

  before(:each) do
    @invoice_repo = InvoiceRepository.new('./data/invoices.csv')
  end

  it 'exists' do
    expect(@invoice_repo).to be_a(InvoiceRepository)
  end

  

end
