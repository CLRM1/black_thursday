require_relative '../lib/customer'
require_relative '../lib/rowable'
require 'pry'
require 'time'
require 'CSV'

class CustomerRepository

  include Rowable

  attr_reader :filename,
              :customers

  def initialize(filename)
    @filename = filename
    @customers = self.all
  end

  def all
    rows.map {|row| Customer.new(row)}
  end

  def current_highest_id
    sorted = @customers.sort_by {|customer| customer.id}
    highest_id = sorted[-1].id
  end

  def find_by_id(id)
    @customers.find {|customer| customer.id == id}
  end

  def find_all_by_first_name(fragment)
    @customers.find_all {|customer| customer.first_name.downcase.include?(fragment.downcase)}
  end

  def find_all_by_last_name(fragment)
    @customers.find_all {|customer| customer.last_name.downcase.include?(fragment.downcase)}
  end

  def create(attributes)
    attributes[:id] = current_highest_id + 1
    attributes[:created_at] = Time.now
    attributes[:updated_at] = Time.now
    @customers << new_customer = Customer.new(attributes)
    return new_customer
  end

  def update(id, attributes)
    if updated_customer = find_by_id(id)
      updated_customer.first_name = attributes[:first_name] if attributes[:first_name]
      updated_customer.last_name = attributes[:last_name] if attributes[:last_name]
      updated_customer.updated_at = Time.now
      updated_customer
    end
  end

  def delete(id)
    @customers.delete(find_by_id(id))
  end

end
