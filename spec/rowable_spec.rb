require_relative '../lib/rowable'
require 'simplecov'
SimpleCov.start

RSpec.describe Rowable do
  describe "Iteration 1" do
    it "exits" do
      repository_module = Rowable.new
      expect(repository_module).to be_a(Rowable)
    end
  end
end
