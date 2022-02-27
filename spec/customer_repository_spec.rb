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

    it 'is initialized with an array of customer objects' do
      expect(@cr.customers).to be_a(Array)
      expect(@cr.customers[0]).to be_a(Customer)
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

  describe '#current_highest_id' do
    it 'can find the current highest id' do
      expect(@cr.current_highest_id).to be_a(Integer)
      expect(@cr.current_highest_id).to eq(1000)
    end
  end


  describe '#find_by_id' do
    it 'can find a customer by its ID' do
      expect(@cr.find_by_id(1)).to be_a(Customer)
      expect(@cr.find_by_id(1).first_name).to eq("Joey")
    end
  end

  describe '#find_all_by_first_name' do
    it 'can find all customers with the same first name' do
      expect(@cr.find_all_by_first_name("Parker").count).to eq(2)
      expect(@cr.find_all_by_first_name("Parker")[0]).to be_a(Customer)
    end
  end

  describe '#find_all_by_last_name' do
    it 'can find all customers with the same last name' do
      expect(@cr.find_all_by_last_name("Miller").count).to eq(2)
      expect(@cr.find_all_by_last_name("Miller")[0]).to be_a(Customer)
    end
  end

  describe '#create' do
    it 'can create a new customer with a set of attributes and an id 1 higher than the current highest' do
      attributes = {first_name: "James", last_name: "Harkins"}

      expect(@cr.create(attributes).id).to eq(1001)
      expect(@cr.find_by_id(1001).first_name).to eq(attributes[:first_name])
    end
  end

  describe '#update' do
    it 'can update some customer with new attributes given an id' do
      attributes = {first_name: "James", last_name: "Harkins"}

      expect(@cr.find_by_id(1).first_name).to eq("Joey")
      expect(@cr.find_by_id(1).last_name).to eq("Ondricka")

      @cr.update(1, attributes)

      expect(@cr.find_by_id(1).first_name).to eq("James")
      expect(@cr.find_by_id(1).last_name).to eq("Harkins")
    end
  end

  describe '#delete' do
    it 'can delete a customer object given its id' do

      @cr.delete(1)

      expect(@cr.find_by_id).to eq(nil)
    end
  end
end
