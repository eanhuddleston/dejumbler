class Dejumbler
  attr_reader :dictionary

  def initialize
    @dictionary = read_dictionary
    @tree = build_trie_tree(dictionary)
  end

  def dejumble(input)
    all_distinct_letter_combos = all_distinct_letter_combos(input)
    all_distinct_letter_combos.delete(input)
    
    identify_real_words(all_distinct_letter_combos)
  end

  def all_distinct_letter_combos(input)
    input_letters = input.split(//)
    all_combos = input_letters.dup
    last_round = input_letters.dup
    input_letters = input_letters.dup

    input.length.times do
      next_round = []
      last_round.each do |word_base|
        input_letters.each do |next_letter|
          possible_word = word_base + next_letter

          unless ( word_base.count(next_letter) >=
              input_letters.count(next_letter) ) ||
              all_combos.include?(possible_word) ||
              !in_tree?(possible_word)

            all_combos << possible_word
            next_round << possible_word
          end
        end
      end
      last_round = next_round.dup
    end

    all_combos
  end

  def in_tree?(possible_word)
    current_node = @tree

    possible_word.each_char do |char|
      match = find_child(current_node, char)
      if match.empty?
        return false
      else
        current_node = match[0]
      end
    end

    true
  end

  def identify_real_words(to_check)
    real_words = []
    to_check.each do |possible_word|
      if dictionary_includes?(possible_word)    
        real_words << possible_word
      end
    end

    real_words.sort
  end

  def dictionary_includes?(possible_word)
    return true if binary_search(dictionary, possible_word)

    false
  end

  def binary_search(array, value, from = 0, to = nil)
    to ||= array.count - 1
    return nil if from > to
 
    middle = (from + to) / 2
 
    if value < array[middle]
      binary_search(array, value, from, middle - 1)
    elsif value > array[middle]
      binary_search(array, value, middle + 1, to)
    else
      middle
    end
  end

  def read_dictionary
    dictionary = []
    File.foreach('dictionary.txt') do |line|
      dictionary << line.chomp
    end

    dictionary
  end

  def build_trie_tree(dictionary)
    top_node = TrieTreeNode.new(nil)
    dictionary = read_dictionary
    dictionary.each do |word|
      node = top_node
      word.each_char do |char|
        match = find_child(node, char)
        if match.empty?
          new_node = TrieTreeNode.new(char)
          node.children << new_node
          node = new_node
        else
          node = match[0]
        end
      end
    end

    top_node
  end

  def find_child(node, char)
    node.children.select { |child| child.value == char }
  end
end

class TrieTreeNode
  attr_accessor :children
  attr_reader :value

  def initialize(value)
    @value = value
    @children = []
  end
end

puts Dejumbler.new.dejumble("phantasmagoria")

