require 'time'

class Customer

  attr_accessor :id,
                :first_name,
                :last_name,
                :created_at,
                :updated_at

  def initialize(attributes)
    @id = attributes[:id].to_i
    @first_name = attributes[:first_name]
    @last_name = attributes[:last_name]
    @created_at = attributes[:created_at].class == Time ? attributes[:created_at] : Time.parse(attributes[:created_at])
    @updated_at = attributes[:updated_at].class == Time ? attributes[:updated_at] : Time.parse(attributes[:updated_at])
  end

end
