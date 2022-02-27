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
  
end
