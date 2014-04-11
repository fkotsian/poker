# Deck.rb
# Part of Poker project
require_relative './card.rb'

class Deck

  attr_reader :cards

  def initialize
    @cards = []
    self.generate_deck
    @cards.shuffle!
  end

  def generate_deck
    suites = {0 => :heart, 1 => :diamond, 2 => :club, 3 => :spade}
    4.times do |suite|
      (2..14).each do |rank|
        @cards << Card.new(rank, suites[suite])
      end
    end
  end

  def draw
    @cards.pop
  end


end
