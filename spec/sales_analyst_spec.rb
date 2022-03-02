require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require 'CSV'
require 'simplecov'
SimpleCov.start

RSpec.describe SalesAnalyst do

  before(:each) do
    @sales_engine = SalesEngine.from_csv({
            :items     => "./data/items.csv",
            :merchants => "./data/merchants.csv",
            :invoices => "./data/invoices.csv",
            :customers => "./data/customers.csv",
            :transactions => "./data/transactions.csv",
            :invoice_items => "./data/invoice_items.csv"
            })
    @sales_analyst = @sales_engine.analyst
  end

  describe 'creates a working sales analyst' do

    xit 'exists' do
      # require 'pry'; binding.pry
      expect(@sales_analyst).to be_a(SalesAnalyst)
    end

    xit 'can calculate average items per merchant' do
      expect(@sales_analyst.average_items_per_merchant).to eq(2.88)
    end

    xit 'can calculate average items per merchant standard deviation' do
      expect(@sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.26)
    end

    xit 'dispays merchants with high item count' do
      expect(@sales_analyst.merchants_with_high_item_count[0]).to be_a(Merchant)
      expect(@sales_analyst.merchants_with_high_item_count.count).to eq(52)
    end

    xit 'finds average item price per merchant' do
      expect(@sales_analyst.average_item_price_for_merchant(12334159)).to be_a(BigDecimal)
      expect(@sales_analyst.average_item_price_for_merchant(12334105).to_f).to eq(16.66)
    end

    xit 'finds average price across all merchants' do
      expect(@sales_analyst.average_average_price_per_merchant).to be_a(BigDecimal)
      expect(@sales_analyst.average_average_price_per_merchant).to eq(350.29)
    end

    xit 'finds items two STD above average price' do
      expect(@sales_analyst.golden_items.length).to eq(5)
      expect(@sales_analyst.golden_items.first.class).to eq(Item)
    end
  end


  describe "#Iteration 2: creates business intelligence" do

    xit 'can determine the average invoices per merchant' do
      expect(@sales_analyst.average_invoices_per_merchant).to eq(10.49)
    end

    xit "can determine the average invoices per merchant's STD" do
      expect(@sales_analyst.average_invoices_per_merchant_standard_deviation).to eq(3.29)
    end

    xit "can determine the top performing merchants" do
      expect(@sales_analyst.top_merchants_by_invoice_count.count).to eq(12)
      expect(@sales_analyst.top_merchants_by_invoice_count[0]).to be_a(Merchant)
    end

    xit "can determine the lowest performing merchants" do
      expect(@sales_analyst.bottom_merchants_by_invoice_count.count).to eq(4)
      expect(@sales_analyst.bottom_merchants_by_invoice_count[0]).to be_a(Merchant)
    end

    xit "can determine the day of the keep based on an invoice" do
      expect(@sales_analyst.invoices_per_day).to be_a(Hash)
      expect(@sales_analyst.invoices_per_day.keys.count).to eq(7)
    end

    xit "can determine average invoices by day" do
      expect(@sales_analyst.average_invoices_per_day).to eq(712)
    end

    xit "can determine invoices by day" do
      expect(@sales_analyst.invoices_by_day.count).to eq(4985)
    end

    xit "can determine invoices by day STD" do
      expect(@sales_analyst.invoices_per_day_STD.round).to eq(18)
    end

    xit "can determine the days with the most sales" do
      expect(@sales_analyst.top_days_by_invoice_count).to eq(["Wednesday"])
    end

    xit "can determine the percentage of invoices based on status" do
      expect(@sales_analyst.invoice_status(:pending)).to eq(29.55)
      expect(@sales_analyst.invoice_status(:shipped)).to eq(56.95)
      expect(@sales_analyst.invoice_status(:returned)).to eq(13.5)
    end
  end

  describe 'Iteration 3: more business intelligence' do
    xit 'can determine if an invoice is paid in full' do
      expect(@sales_analyst.invoice_paid_in_full?(1)).to eq(true)
      expect(@sales_analyst.invoice_paid_in_full?(200)).to eq(true)
      expect(@sales_analyst.invoice_paid_in_full?(204)).to eq(false)
    end

    it 'can determine the total dollar amount for an invoice for all non-failed transactions' do
      expect(@sales_analyst.invoice_total(1)).to eq 21067.77
      expect(@sales_analyst.invoice_total(1).class).to eq BigDecimal
    end
  end

  describe 'Iteration 4: Merchant Analytics' do
    it 'can determine if invoices have unique created dates' do
      n = @sales_analyst.invoices.invoices.count
      b = @sales_analyst.invoices.invoices.map do |invoice|
        invoice.created_at
        end
      expect(n).to eq(b.count)
    end

    it 'can determine total revenue by date' do
      time = Time.parse("2009-02-07")
      expect(@sales_analyst.total_revenue_by_date(time).class).to eq(BigDecimal)
    end


    xit 'can determine revenue by invoice id' do
      expect(@sales_analyst.revenue_by_invoice_id(1)).to eq(21067.77)
    end

    it 'can determine top revenue earners' do
      expect(@sales_analyst.top_revenue_earners(5).first).to be_a(Merchant)
      expect(@sales_analyst.top_revenue_earners(5).count).to eq(5)

    end

    it 'can determine merchants with pending invoices' do
      expect(@sales_analyst.merchants_with_pending_invoices.class).to eq(Array)
      expect(@sales_analyst.merchants_with_pending_invoices.first.class).to eq(Merchant)

    end

    it 'can determine merchants with one item' do
      expect(@sales_analyst.merchants_with_only_one_item.class).to eq(Array)
      expect(@sales_analyst.merchants_with_only_one_item.first).to be_a(Merchant)
    end

    xit 'can determine merchants that only sell one item by month registered' do
      expect(@sales_analyst.merchants_with_only_one_item_registered_in_month("June").class).to eq(Array)
      expect(@sales_analyst.merchants_with_only_one_item_registered_in_month("June").first).to be_a(Merchant)
    end

    it 'can determine the total revenue for a single merchant' do
      expect(@sales_analyst.revenue_by_merchant(merchant_id)).to eq(1.5)
    end





  end

end
