class Hand
  attr_reader :cards

  HAND_RANKS = {
    :royal_flush  => 10,
    :straight_flush => 9,
    :four_of_a_kind => 8,
    :full_house => 7,
    :flush  => 6,
    :straight => 5,
    :three_of_a_kind  => 4,
    :two_pair => 3,
    :one_pair => 2,
    :high_card  => 1
  }


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

  def display
    p self.cards.map { |card| [card.rank, card.suit] }
  end

  def add_cards(new_cards)
    raise "Can't receive more than 3 cards." if new_cards.count > 3
    raise "Can't have more than 5 cards." if self.cards.count + new_cards.count > 5

    @cards += new_cards
  end


  def beats_hand(other_hand)
    return :won if HAND_RANKS[self.evaluate_hand] > HAND_RANKS[other_hand.evaluate_hand]
    return :lost if HAND_RANKS[self.evaluate_hand] < HAND_RANKS[other_hand.evaluate_hand]

    case self.evaluate_hand
    when :royal_flush
      return :draw
    when :straight_flush, :straight
      return compare_high_cards(other_hand)
    when :four_of_a_kind
      return compare_four_of_a_kind(other_hand)
    when :full_house
      return compare_full_house(other_hand)
    when :flush
      return compare_flush(other_hand)
    when :three_of_a_kind
      return compare_three_of_a_kind(other_hand)
    when :two_pair
      return compare_two_pairs(other_hand)
    when :pair
      return compare_pairs(other_hand)
    when :high_card
      return compare_high_card(other_hand)
    end
  end

  def compare_high_cards(other_hand)
    own_high_card = cards.sort_by(&:rank).last
    other_high_card = other_hand.cards.sort_by(&:rank).last

    return :won if own_high_card.rank > other_high_card.rank
    return :lost if own_high_card.rank < other_high_card.rank
    return :draw
  end

  def compare_full_house(other_hand)
    own_card_counts = get_card_counts(self)
    other_card_counts = get_card_counts(other_hand)

    own_trick_card = own_card_counts.key(3)
    other_trick_card = other_card_counts.key(3)

    return :won if own_trick_card > other_trick_card
    return :lost if own_trick_card < other_trick_card

    own_kicker = own_card_counts.key(2)
    other_kicker = other_card_counts.key(2)

    return :won if own_kicker > other_kicker
    return :lost if own_kicker < other_kicker

    return :draw
  end

  def compare_four_of_a_kind(other_hand)
    own_card_counts = get_card_counts(self)
    other_card_counts = get_card_counts(other_hand)

    own_trick_card = own_card_counts.key(4)
    other_trick_card = other_card_counts.key(4)

    return :won if own_trick_card > other_trick_card
    return :lost if own_trick_card < other_trick_card
  end

  def compare_flush(other_hand)
    own_sorted_hand = cards.sort_by(&:rank).reverse
    other_sorted_hand = other_hand.cards.sort_by(&:rank).reverse

    (0..4).each do |card|
      return :won if own_sorted_hand[card].rank > other_sorted_hand[card].rank
      return :lost if own_sorted_hand[card].rank < other_sorted_hand[card].rank
    end

    return :draw
  end

  def compare_three_of_a_kind(other_hand)
    own_card_counts = get_card_counts(self)
    other_card_counts = get_card_counts(other_hand)

    own_trick_card = own_card_counts.key(3)
    other_trick_card = other_card_counts.key(3)

    return :won if own_trick_card > other_trick_card
    return :lost if own_trick_card < other_trick_card
  end

  def compare_two_pairs(other_hand)
    own_card_counts = get_card_counts(self)
    other_card_counts = get_card_counts(other_hand)

    own_pairs = own_card_counts.map{ |k,v| v==2 ? k : nil }.compact.sort
    other_pairs = other_card_counts.map{ |k,v| v==2 ? k : nil }.compact.sort

    return :won if own_pairs.last > other_pairs.last
    return :lost if own_pairs.last < other_pairs.last

    return :won if own_pairs.first > other_pairs.first
    return :lost if own_pairs.first < other_pairs.first

    own_kicker = own_card_counts.key(1)
    other_kicker = other_card_counts.key(1)

    return :won if own_kicker > other_kicker
    return :lost if own_kicker < other_kicker

    return :draw
  end


  def compare_pairs(other_hand)
    own_card_counts = get_card_counts(self)
    other_card_counts = get_card_counts(other_hand)

    own_trick = own_card_counts.key(2)
    other_trick = other_card_counts.key(2)

    return :won if own_trick > other_trick
    return :lost if own_trick < other_trick

    own_kickers = own_card_counts.map{ |k,v| v==1 ? k : nil }.compact.sort.reverse
    other_kickers = other_card_counts.map{ |k,v| v==1 ? k : nil }.compact.sort.reverse

    (0..2).each do |card|
      return :won if own_kickers[card] > other_kickers[card]
      return :lost if own_kickers[card] < other_kickers[card]
    end

    return :draw
  end

  def compare_high_cards(other_hand)
    own_sorted_hand = self.cards.sort_by(&:rank).reverse
    other_sorted_hand = other_hand.cards.sort_by(&:rank).reverse

    (0..4).each do |card|
      return :won if own_sorted_hand[card] > other_sorted_hand[card]
      return :lost if own_sorted_hand[card] < other_sorted_hand[card]
    end

    return :draw
  end


  def get_card_counts(hand)
    card_counts = Hash.new(0)
    hand.cards.each do |card|
      card_counts[card.rank] += 1
    end
    card_counts
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

    return :royal_flush if flush && straight && cards.any? { |card| card.rank == 14 } && cards.any? { |card| card.rank == 13 }
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