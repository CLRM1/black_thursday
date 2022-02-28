require 'bigdecimal'
require 'CSV'
require 'time'

class Transaction

  attr_accessor :id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at

  def initialize(attributes)
    @id = attributes[:id].to_i
    @invoice_id = attributes[:invoice_id].to_i
    @credit_card_number = attributes[:credit_card_number]
    @credit_card_expiration_date = attributes[:credit_card_expiration_date]
    @result = attributes[:result].to_sym
    @created_at = attributes[:created_at].class == Time ? attributes[:created_at] : Time.parse(attributes[:created_at])
    @updated_at = attributes[:updated_at].class == Time ? attributes[:updated_at] : Time.parse(attributes[:updated_at])
  end

end
