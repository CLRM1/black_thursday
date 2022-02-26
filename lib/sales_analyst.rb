require_relative '../lib/item'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'

require 'bigdecimal'
require 'pry'
require 'CSV'

class SalesAnalyst

  def initialize(merchants, items, invoices)
    @merchants = merchants
    @items = items
    @invoices = invoices
  end

  def average_items_per_merchant
    merchant_ids = @items.items.map {|item| item.merchant_id}
    merchant_items = Hash.new(0)
    merchant_ids.each do |id|
      merchant_items[id] += 1
    end
    ((merchant_items.values.sum).to_f / merchant_items.keys.count).round(2)
  end

  def average_items_per_merchant_standard_deviation
    merchant_ids = @items.items.map {|item| item.merchant_id}
    merchant_items = Hash.new(0)
    merchant_ids.each do |id|
      merchant_items[id] += 1
    end

    average_merchant_items = ((merchant_items.values.sum).to_f / merchant_items.keys.count)
    empty = []
    merchant_items.values.each do |number|
      result = (number - average_merchant_items) * (number - average_merchant_items)
      empty << result
    end

    Math.sqrt(empty.sum / (merchant_items.count - 1)).round(2)
  end

  def merchants_with_high_item_count
    merchant_ids = @items.items.map {|item| item.merchant_id}
    merchant_items = Hash.new(0)
    merchant_ids.each do |id|
      merchant_items[id] += 1
    end

    average_merchant_items = ((merchant_items.values.sum).to_f / merchant_items.keys.count)
    item_count_standard = average_merchant_items + average_items_per_merchant_standard_deviation

    high_item_count_merchants_id = merchant_items.find_all do |key,value|
      key if value > item_count_standard
    end

    high_item_count_merchants_id.map do |merchants_id|
      @merchants.find_by_id(merchants_id[0])
    end
  end

  def average_item_price_for_merchant(merchant_id)
    merchant_items = @items.find_all_by_merchant_id(merchant_id)
    merchant_item_prices = merchant_items.map {|item| item.unit_price}
    (merchant_item_prices.sum / merchant_item_prices.count).round(2)
  end

  def average_average_price_per_merchant
    merchant_ids = @merchants.merchants.map {|merchant| merchant.id}
    averages = merchant_ids.map { |id| average_item_price_for_merchant(id)}
    (averages.sum / averages.count).round(2)
  end

  def average_item_price
    item_prices = @items.items.map {|item| item.unit_price_to_dollars}
    item_prices.sum / item_prices.length
  end

  def item_price_std
    item_prices = @items.items.map {|item| item.unit_price_to_dollars}
    sq_item_prices = item_prices.map do|price|
      (price - average_item_price) ** 2
    end
    Math.sqrt(sq_item_prices.sum / (sq_item_prices.count - 1))
  end

  def golden_items
    golden_minimum = (average_item_price + (item_price_std * 2))
    @items.items.find_all do |item|
      item.unit_price_to_dollars > golden_minimum
    end
  end

  def average_invoices_per_merchant
    merchant_ids = @invoices.invoices.map {|invoice| invoice.merchant_id}
    merchant_invoices = Hash.new(0)
    merchant_ids.each do |id|
      merchant_invoices[id] += 1
    end
    ((merchant_invoices.values.sum).to_f / merchant_invoices.keys.count).round(2)
  end

end
