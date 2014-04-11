# poker_spec.rb

# require 'test_helper.rb'
require 'card'


describe 'Card' do
  subject(:card) { Card.new(10, :spade) }

  it "should return the correct suit" do
    expect( Card.new(14, :spade).suit ).to eq(:spade)
  end

  it "should return the correct rank" do
    expect( card.rank ).to eq(10)
  end
end