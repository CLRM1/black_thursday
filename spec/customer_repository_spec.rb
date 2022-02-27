require_relative '../lib/customer'
require_relative '../lib/customer_repository'
require 'simplecov'
SimpleCov.start

RSpec.describe CustomerRepository do

  before(:each) do
    @cr = CustomerRepository.new('./data/customers.csv')
  end

  describe '#initialize' do
    it 'is initialized with a filename' do
      expect(@cr.filename).to eq('./data/customers.csv')
    end
  end

  describe '#rows' do
    it 'can create a CSV::Table object from which to create our customer objects' do
      expect(@cr.rows).to be_a(CSV::Table)
    end
  end

  describe '#all' do
    it 'can read the CSV::Table object from Rows and create a customer object for each line' do
      expect(@cr.all).to be_a(Array)
      expect(@cr.all[0]).to be_a(Customer)
    end
  end

end
