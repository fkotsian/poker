class Hand
  attr_reader :cards


  def initialize(dealt_card_arr)
    @cards = dealt_card_arr
  end

  def discard_cards(positions)
    raise "Can't discard more than 3 cards." if positions.count > 3
    raise "Can't discard card not in hand." if positions.any? { |position| !position.between?(1, 5)}

    positions.sort!.reverse!

    positions.each do |position|
      @cards.delete_at(position-1)
    end
  end

  def evaluate_hand
    duplicate_ranks = Hash.new(0)


    self.cards.each do |card|
      duplicate_ranks[card.rank] += 1
    end

    max_duplicates = duplicate_ranks.values.max

    return :four_of_a_kind if max_duplicates == 4
    return :full_house if duplicate_ranks.values.include?(3) && duplicate_ranks.values.include?(2)
    return :three_of_a_kind if duplicate_ranks.values.include?(3)
    return :two_pair if duplicate_ranks.values.select { |val| val == 2 }.count == 2
    return :one_pair if duplicate_ranks.values.include?(2)

    flush = is_flush?
    straight = is_straight?

    return :royal_flush if flush && straight && cards.any? { |card| card.rank == 14 } && cards.any? { |card| card.rank == 13f }
    return :straight_flush if flush && straight
    return :straight if straight
    return :flush if flush
    return :high_card

  end

  def is_flush?
    self.cards.all? { |card| card.suit == self.cards.first.suit }
  end

  def is_straight?
    sorted_cards = cards.sort_by(&:rank)
    return true if (sorted_cards.last.rank - sorted_cards.first.rank == 4)
    return true if sorted_cards.last.rank == 14 && sorted_cards[-2].rank == 5
    return false
  end


end