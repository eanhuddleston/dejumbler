def dejumble(word)
  to_check = word.split(//)
  last_round = word.split(//)
  word_letters = word.split(//)

  word.length.times do
    next_round = []
    last_round.each do |word_base|
      word_letters.each do |next_letter|
        unless word_base.include?(next_letter)
          to_check << word_base + next_letter
          next_round << word_base + next_letter
        end
      end
    end

    last_round = next_round.dup
  end

  new_real_words = find_real_words(to_check, word)
  distinct_words = remove_duplicates(new_real_words).sort
  
  distinct_words
end

def find_real_words(to_check, word)
  new_real_words = []
  corpus = read_corpus
  to_check.each do |possible_word|
    if corpus.include?(possible_word) &&
          possible_word != word
      new_real_words << possible_word
    end
  end

  new_real_words
end

def read_corpus
  corpus = []
  File.foreach('2of12inf.txt') do |line|
    corpus << line.chomp
  end

  corpus
end

def remove_duplicates(new_real_words)
  distinct_words = []
  new_real_words.each do |word|
    distinct_words << word if !distinct_words.include?(word)
  end

  distinct_words
end
