require_relative '../lib/customer'
require 'simplecov'
SimpleCov.start

RSpec.describe Customer do

  context 'create Customer class' do
    c = Customer.new({
      :id => 6,
      :first_name => "Joan",
      :last_name => "Clarke",
      :created_at => Time.now,
      :updated_at => Time.now
    })

    it 'exists' do
      expect(c).to be_an_instance_of(Customer)
    end

    it 'has attributes' do
      expect(c.id).to eq(6)
      expect(c.first_name).to eq("Joan")
      expect(c.last_name).to eq("Clarke")
      expect(c.created_at).to be_a(Time)
      expect(c.updated_at).to be_a(Time)
    end
  end
end
