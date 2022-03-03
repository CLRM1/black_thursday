require_relative '../lib/item'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'
require_relative '../lib/customer'
require_relative '../lib/customer_repository'
require_relative '../lib/transaction'
require_relative '../lib/transaction_repository'
require_relative '../lib/invoice_item'
require_relative '../lib/invoice_item_repository'

require 'bigdecimal'
require 'pry'
require 'CSV'
require 'Date'

class SalesAnalyst

  attr_reader :merchants,
              :items,
              :invoices,
              :customers,
              :transactions,
              :invoice_items

  def initialize(merchants, items, invoices, customers, transactions, invoice_items)
    @merchants = merchants
    @items = items
    @invoices = invoices
    @customers = customers
    @transactions = transactions
    @invoice_items = invoice_items
  end

  def item_count_per_merchant
    merchant_ids = @items.items.map {|item| item.merchant_id}
    merchant_items = Hash.new(0)
    merchant_ids.each do |id|
      merchant_items[id] += 1
    end
    merchant_items
  end

  def average_items_per_merchant
    ((item_count_per_merchant.values.sum).to_f / item_count_per_merchant.keys.count).round(2)
  end

  def merchant_item_variance
    item_count_per_merchant.values.map do |number|
      (number - average_items_per_merchant) ** 2
    end.sum
  end

  def average_items_per_merchant_standard_deviation
    Math.sqrt(merchant_item_variance / (item_count_per_merchant.count - 1)).round(2)
  end

  def merchants_with_high_item_count
    item_count_standard = average_items_per_merchant + average_items_per_merchant_standard_deviation
    high_item_count_merchants_id = item_count_per_merchant.find_all do |key,value|
      key if value > item_count_standard
    end
    high_item_count_merchants_id.map{|merchants_id| @merchants.find_by_id(merchants_id[0])}
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

  def invoice_count_per_merchant
    merchant_ids = @invoices.invoices.map {|invoice| invoice.merchant_id}
    merchant_invoices = Hash.new(0)
    merchant_ids.each do |id|
      merchant_invoices[id] += 1
    end
    merchant_invoices
  end

  def average_invoices_per_merchant
    (invoice_count_per_merchant.values.sum.to_f / invoice_count_per_merchant.keys.count).round(2)
  end

  def merchant_invoice_variance
    invoice_count_per_merchant.values.map do |number|
      (number - average_invoices_per_merchant) ** 2
    end.sum
  end

  def average_invoices_per_merchant_standard_deviation
    Math.sqrt(merchant_invoice_variance / (invoice_count_per_merchant.count - 1)).round(2)
  end

  def top_merchants_by_invoice_count
    golden_invoices = (average_invoices_per_merchant + (average_invoices_per_merchant_standard_deviation * 2))
    golden_merchants = invoice_count_per_merchant.select do |merchant, invoice_count|
      invoice_count > golden_invoices
    end
    golden_merchants.keys.map {|id| @merchants.find_by_id(id)}
  end

  def bottom_merchants_by_invoice_count
    ungolden_invoices = (average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2))
    ungolden_merchants = invoice_count_per_merchant.select do |merchant, invoice_count|
      invoice_count < ungolden_invoices
    end
    ungolden_merchants.keys.map {|id| @merchants.find_by_id(id)}
  end

  def invoices_by_day
    @invoices.invoices.map do |invoice|
      invoice.created_at.class == Time ?
      invoice.created_at.wday : Time.parse(invoice.created_at).wday
    end
  end

  def invoices_per_day
    invoices_per_day_hash = Hash.new(0)
    invoices_by_day.each do |day|
      invoices_per_day_hash[day] += 1
    end
    invoices_per_day_hash
  end

  def average_invoices_per_day
    invoices_per_day.values.sum / 7
  end

  def invoices_per_day_STD
    square_difference_sum = invoices_per_day.values.map do |day_count|
      (day_count - average_invoices_per_day) ** 2
    end.sum
    Math.sqrt(square_difference_sum / (invoices_per_day.values.count - 1))
  end

  def num_to_day_converter(num)
    Date::DAYNAMES[num]
  end

  def top_days_by_invoice_count
    golden_day_count = average_invoices_per_day + invoices_per_day_STD
    golden_days = invoices_per_day.select do |day_of_the_week, num_invoices|
      num_invoices > golden_day_count
    end
    golden_weekdays = golden_days.keys.map {|day| num_to_day_converter(day)}
  end

  def invoice_status(status)
    invoices_by_status = @invoices.invoices.find_all do |invoice|
      invoice.status == status
    end
    ((invoices_by_status.count.to_f / @invoices.invoices.count) * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    invoice_transactions = @transactions.find_all_by_invoice_id(invoice_id)
    !invoice_transactions.empty? ? invoice_transactions.all? {|transaction| transaction.result == :success} : false
  end

  def invoice_total(invoice_id)
    @invoice_items.find_all_by_invoice_id(invoice_id).map do |invoice_item|
      (invoice_item.unit_price * invoice_item.quantity)
    end.sum
  end

  def total_revenue_by_date(date)
    invoice_id = @invoices.find_by_created_at(date).id
    @invoice_items.find_all_by_invoice_id(invoice_id).map do |invoice_item|
      (invoice_item.unit_price * invoice_item.quantity)
    end.sum
  end

  def revenue_by_invoice_id(invoice_id)
    @invoice_items.find_all_by_invoice_id(invoice_id).map do |invoice_item|
      (invoice_item.unit_price * invoice_item.quantity)
    end.sum
  end

  def invoices_by_merchant_id
    merchant_ids = @merchants.merchants.map {|merchant| merchant.id}
    merchant_ids.map do |merchant_id|
      @invoices.find_all_by_merchant_id(merchant_id)
    end
  end

  def merchant_revenues
    merchant_revenues_hash = Hash.new(0)
    invoices_by_merchant_id.each do |merchant_invoices|
      merchant_invoices.each do |invoice|
        if @transactions.all_successful_transactions.include?(invoice.id)
          merchant_revenues_hash[@merchants.find_by_id(invoice.merchant_id)] += revenue_by_invoice_id(invoice.id)
        end
      end
    end
    merchant_revenues_hash
  end

  def top_revenue_earners(amount_of_merchants = 20)
    sorted = merchant_revenues.sort_by { |key, value| value }.reverse
    sorted_merchants = sorted.map {|merchant_and_value| merchant_and_value.first}
    sorted_merchants[0..(amount_of_merchants - 1)]
  end

  def pending_merchant_ids
    @invoices.invoices.map do |invoice|
      if @transactions.find_all_by_invoice_id(invoice.id).all? {|transaction| transaction.result == :failed}
        invoice.merchant_id
      end
    end.compact
  end

  def merchants_with_pending_invoices
    pending_merchant_ids.map do |merchant_id|
      @merchants.find_by_id(merchant_id)
    end.uniq
  end

  def merchants_with_only_one_item_registered_in_month(month)
    month_index = Time.parse(month).month
    one_item_merchants = {}
    merchants_with_only_one_item.each {|merchant|
      one_item_merchants[merchant] = merchant.created_at.month}
    one_item_merchants.map {|merchant, created_at|
      merchant if created_at == month_index}.compact
  end

  def merchant_items
    merchant_ids = @items.items.map {|item| item.merchant_id}
    merchant_items_hash = Hash.new(0)
    merchant_ids.each do |id|
      merchant_items_hash[id] += 1
    end
    merchant_items_hash
  end

  def merchants_with_only_one_item
    single_item_merchants = merchant_items.map do |merchant_id, num_of_items|
      if num_of_items == 1
        @merchants.find_by_id(merchant_id)
      end
    end.compact
  end

  def revenue_by_merchant(merchant_id)
    @invoices.find_all_by_merchant_id(merchant_id).map do |invoice|
      if @transactions.find_all_by_invoice_id(invoice.id).all?{|transaction| transaction.result == :success}
        @invoice_items.find_all_by_invoice_id(invoice.id).map do |invoice_item|
          invoice_item.unit_price
        end.sum
      end
    end.compact.sum
  end

  def invoice_items_by_quantity(merchant_id)
    invoice_items_by_quantity_hash = Hash.new(0)
    @invoices.find_all_by_merchant_id(merchant_id).each do |invoice|
      @invoice_items.find_all_by_invoice_id(invoice.id).each do |invoice_item|
        invoice_items_by_quantity_hash[invoice_item] += invoice_item.quantity
      end
    end
    invoice_items_by_quantity_hash
  end

  def most_sold_item_for_merchant(merchant_id)
    sorted = invoice_items_by_quantity(merchant_id).sort_by {|key, value| value}.reverse
    sorted_invoice_items = sorted.find_all {|invoice_item| invoice_item[0].quantity == sorted[0][0].quantity}
    winners = sorted_invoice_items.map {|invoice_item_array| invoice_item_array[0]}
    winners.map {|invoice_item| @items.find_by_id(invoice_item.item_id)}
  end

  def invoice_items_by_revenue(merchant_id)
    invoice_items_by_revenue_hash = Hash.new(0)
    @invoices.find_all_by_merchant_id(merchant_id).each do |invoice|
      if invoice_paid_in_full?(invoice.id)
        @invoice_items.find_all_by_invoice_id(invoice.id).each do |invoice_item|
          invoice_items_by_revenue_hash[invoice_item] += (invoice_item.unit_price * invoice_item.quantity)
        end
      end
    end
    invoice_items_by_revenue_hash
  end

  def best_item_for_merchant(merchant_id)
    sorted = invoice_items_by_revenue(merchant_id).sort_by {|key, value| value}.reverse
    winner = sorted[0][0]
    @items.find_by_id(winner.item_id)
  end

end
