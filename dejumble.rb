def dejumble(input)
  all_distinct_combos = all_distinct_letter_combos(input)
  new_real_words = find_new_real_words(all_distinct_combos, input)
  
  new_real_words
end

def all_distinct_letter_combos(input)
  all_combos = input.split(//)
  last_round = input.split(//)
  input_letters = input.split(//)

  input.length.times do
    next_round = []
    last_round.each do |word_base|
      input_letters.each do |next_letter|
        unless ( word_base.count(next_letter) >=
            input_letters.count(next_letter) ) ||
            all_combos.include?(word_base + next_letter)

          all_combos << word_base + next_letter
          next_round << word_base + next_letter
        end
      end
    end
    last_round = next_round.dup
  end

  all_combos
end

def find_new_real_words(to_check, word)
  new_real_words = []
  corpus = read_corpus
  to_check.each do |possible_word|
    if possible_word != word &&
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
