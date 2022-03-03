module Rowable

  def rows
    CSV.read(@filename, headers: true, header_converters: :symbol)
  end

  def inspect
   "#<#{self.class} #{@merchants.size} rows>"
  end

end
