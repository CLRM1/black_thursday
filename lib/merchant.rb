class Merchant

  attr_accessor :id,
                :name,
                :created_at

  def initialize(attributes)
    @id = attributes[:id].to_i
    @name = attributes[:name]
    @created_at = attributes[:created_at].class == Time ?
                  attributes[:created_at] : Time.parse(attributes[:created_at])
  end

end
