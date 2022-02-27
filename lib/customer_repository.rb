require_relative '../lib/customer'
require 'pry'
require 'time'
require 'CSV'

class CustomerRepository

  attr_reader :filename,
              :customers

  def initialize(filename)
    @filename = filename
    @customers = self.all
  end

  def rows
    CSV.read(@filename, headers: true, header_converters: :symbol)
  end


  def all
    rows.map {|row| Customer.new(row)}
  end

  def find_by_id(id)
    @customers.find {|customer| customer.id == id}
  end

end
