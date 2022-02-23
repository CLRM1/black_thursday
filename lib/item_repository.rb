require_relative '../lib/item'
require 'CSV'


class ItemRepository
  attr_reader :filename, :items

  def initialize(filename)
    @filename = filename
    @items = self.all
  end

  def rows
    rows = CSV.read(@filename, headers: true, header_converters: :symbol)
  end


  def all
    result = rows.map {|row| Item.new(row)}
  end

  def find_by_id(id)
    @items.find do |item|
      if item.id == id
        item
      end
    end
  end

  def find_by_name(name)
    @items.find do |item|
      if item.name == name
        item
      end
    end
  end




end
