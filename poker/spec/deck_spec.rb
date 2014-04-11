require 'card'
require 'deck'


describe "Deck" do
  subject(:deck) {Deck.new}

  context "#initialize" do
    it "should generate an array of 52 cards" do
      expect(Deck.new.cards.select { |card| card.is_a?(Card) }.count).to eq(52)
    end
  end

  context "#draw" do
    it "should return a card" do
      expect(deck.draw).to be_a(Card)
    end

    it "should remove a card from the deck" do
      deck.draw
      expect(deck.cards.count).to eq(51)
    end
  end

end