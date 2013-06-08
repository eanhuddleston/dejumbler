class Dejumbler
  def initialize
    @corpus = read_corpus
    @tree = build_trie_tree(@corpus)
  end

  def dejumble(input)
    all_distinct_combos = all_distinct_letter_combos(input)
    new_real_words = find_new_real_words(all_distinct_combos, input)
    
    puts new_real_words
    new_real_words
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
              all_combos.include?(possible_word)

            if in_tree?(possible_word)
              all_combos << possible_word
              next_round << possible_word
            end
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

  def find_new_real_words(to_check, input)
    new_real_words = []
    corpus = read_corpus
    to_check.each do |possible_word|
      if possible_word != input &&
          corpus_includes?(possible_word, corpus)
            
        new_real_words << possible_word
      end
    end

    new_real_words.sort
  end

  def corpus_includes?(possible_word, corpus) 
    while true
      middle = (corpus.length - 1) / 2

      if corpus[middle] == possible_word
        return true
      elsif possible_word < corpus[middle]
        return false if middle == 0
        corpus = corpus[0...middle]
      elsif possible_word > corpus[middle]
        return false if middle == corpus.length - 1
        corpus = corpus[middle+1..corpus.length-1]
      end
    end
  end

  def read_corpus
    corpus = []
    File.foreach('dictionary.txt') do |line|
      corpus << line.chomp
    end

    corpus
  end

  def build_trie_tree(corpus)
    top_node = TreeNode.new(nil, nil)
    corpus = read_corpus
    corpus.each do |word|
      node = top_node
      word.each_char do |char|
        match = find_child(node, char)
        if match.empty?
          new_node = TreeNode.new(node, char)
          node.children << new_node
          node = new_node
        else
          node = match[0] # move to that node
        end
      end
    end

    top_node
  end

  def find_child(node, char)
    node.children.select { |child| child.value == char }
  end
end

class TreeNode
  attr_accessor :children
  attr_reader :value

  def initialize(parent, value)
    @parent = parent
    @value = value
    @children = []
  end
end

Dejumbler.new.dejumble("phantasmagoria")

