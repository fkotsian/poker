require 'hand'
require 'deck'
require 'card'

describe "Hand" do

  let(:dA) { Card.new(14, :diamond) }
  let(:cA) { Card.new(14, :club   ) }
  let(:hA) { Card.new(14, :heart  ) }
  let(:sA) { Card.new(14, :spade  ) }
  let(:sK) { Card.new(13, :spade  ) }
  let(:sQ) { Card.new(12, :spade  ) }
  let(:sJ) { Card.new(11, :spade  ) }
  let(:sT) { Card.new(10, :spade  ) }
  let(:s9) { Card.new( 9, :spade  ) }
  let(:s8) { Card.new( 8, :spade  ) }
  let(:s7) { Card.new( 7, :spade  ) }
  let(:s6) { Card.new( 6, :spade  ) }
  let(:s5) { Card.new( 5, :spade  ) }
  let(:s4) { Card.new( 4, :spade  ) }
  let(:s3) { Card.new( 3, :spade  ) }
  let(:s2) { Card.new( 2, :spade  ) }




  let(:c1) { Card.new(2, :spade) }
  let(:c2) { Card.new(3, :spade) }
  let(:c3) { Card.new(4, :spade) }
  let(:c4) { Card.new(5, :spade) }
  let(:c5) { Card.new(6, :spade) }

  subject(:hand) { Hand.new([c1, c2, c3, c4, c5]) }

  it "should be created with 5 cards" do
     expect(hand.cards.count).to eq(5)
  end

  context "#discard_cards" do

    it "raises an exception if more than 3 cards are chosen" do
     expect { hand.discard_cards([1, 2, 3, 4]) }.to raise_exception("Can't discard more than 3 cards.")
    end

    it "raises an exception if a chosen card is not in the hand" do
      expect { hand.discard_cards([5, 6])}.to raise_exception("Can't discard card not in hand.")
    end

    # begin { hand.discard_cards( [1,2] ) }
    it "should discard the requested number of cards" do
      hand.discard_cards([1, 2])
      expect(hand.cards.count).to eq(3)
    end

    it "should discard the requested cards" do
      hand.discard_cards([1, 3])
      expect( hand.cards ).to_not include(c1)
      expect( hand.cards ).to_not include(c3)
      expect( hand.cards ).to include(c2)
      expect( hand.cards ).to include(c4)
      expect( hand.cards ).to include(c5)
    end

  end

  context "#add_cards" do

    it "should raise an exception if a player would receive more than 3 cards" do
      expect{ hand.add_cards([c1, c2, c3, c4]) }.to raise_exception ( "Can't receive more than 3 cards." )
    end

    it "should raise an exception if a hand would contain more than 5 cards" do
      expect{ hand.add_cards([c1, c3, c4]) }.to raise_exception ( "Can't have more than 5 cards." )
    end

    it "should add a set of cards from the dealer to the hand" do
      hand.discard_cards([1, 2])
      hand.add_cards( [c4, c5] )
      expect(hand.cards.count).to eq(5)
    end

  end

  context "#evaluate_hand" do

    it "recognizes a royal flush" do
      expect(Hand.new( [sA, sK, sQ, sJ, sT] ).evaluate_hand).to eq(:royal_flush)
    end

    it "recognizes a straight flush" do
      expect(Hand.new( [s9, sK, sQ, sJ, sT] ).evaluate_hand).to eq(:straight_flush)
    end

    it "recognizes a four-of-a-kind" do
      expect(Hand.new( [sA, hA, dA, cA, s2] ).evaluate_hand).to eq(:four_of_a_kind)
    end

    it "recognizes a full house" do
      expect(Hand.new( [sA, hA, dA, s2, s2] ).evaluate_hand).to eq(:full_house)

    end

    it "recognizes a flush" do
      expect(Hand.new( [s2, s3, s4, s5, sK] ).evaluate_hand).to eq(:flush)
    end

    it "recognizes a straight" do
      expect(Hand.new( [s2, s3, s4, s5, dA] ).evaluate_hand).to eq(:straight)
    end

    it "recognizes three-of-a-kind" do
      expect(Hand.new( [sA, hA, dA, s3, s5] ).evaluate_hand).to eq(:three_of_a_kind)
    end

    it "recognizes two pair" do
      expect(Hand.new( [sA, hA, s2, s2, s5] ).evaluate_hand).to eq(:two_pair)
    end

    it "recognized a pair" do
      expect(Hand.new( [sA, hA, s2, s3, s5] ).evaluate_hand).to eq(:one_pair)
    end

    it "recognizes high card" do
      expect(Hand.new( [s2, s4, s6, s9, cA] ).evaluate_hand).to eq(:high_card)
    end

  end

  context "#beats_hand" do

    let(:royal_flush) {Hand.new( [sA, sK, sQ, sJ, sT])}
    let(:straight_flush) {Hand.new( [s9, sK, sQ, sJ, sT] )}
    let(:four_of_a_kind) {Hand.new( [sA, hA, dA, cA, s2] )}
    let(:full_house)     {Hand.new( [sA, hA, dA, s2, s2] )}
    let(:flush)          {Hand.new( [s2, s3, s4, s5, sK] )}
    let(:straight)       {Hand.new( [s2, s3, s4, s5, dA] )}
    let(:three_of_a_kind){Hand.new( [sA, hA, dA, s3, s5] )}
    let(:two_pair)       {Hand.new( [sA, hA, s2, s2, s5] )}
    let(:one_pair)       {Hand.new( [sA, hA, s2, s3, s5] )}
    let(:high_card)      {Hand.new( [s2, s4, s6, s9, cA] )}

    let(:inferior_four_of_a_kind) {Hand.new( [sK, sK, sK, sK, hA] )}

    it "High hand beats lower hand" do
      expect(royal_flush.beats_hand(straight_flush)).to be(:won)
    end

    it "Lower hand does not beat higher hand" do
      expect(straight_flush.beats_hand(royal_flush)).to be(:lost)
    end

    it "Trick does not beat equivalent trick" do
      expect(two_pair.beats_hand(two_pair)).to be(:draw)
    end

    it "Better trick beats other, same trick" do
      expect(four_of_a_kind.beats_hand(inferior_four_of_a_kind)).to be(:won)
    end


  end


end