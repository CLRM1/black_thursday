require_relative '../lib/customer'
require_relative '../lib/customer_repository'
require 'simplecov'
SimpleCov.start

RSpec.describe CustomerRepository do

  before(:each) do
    cr = CustomerRepository.new('./data/customers.csv')
  end

  describe '#initialize' do
    it 'is initialized with a filename' do
      expect(@cr.filename).to eq('./data/customers.csv')
    end
  end

end
