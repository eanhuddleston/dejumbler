def dejumble(word)
  to_check = word.split(//)
  last_round = word.split(//)
  word_letters = word.split(//)

  word.length.times do
    next_round = []
    last_round.each do |word_base|
      word_letters.each do |next_letter|
        unless word_base.count(next_letter) >=
              word_letters.count(next_letter)
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
    if possible_word != word &&
        corpus_includes?(possible_word, corpus)
          
      new_real_words << possible_word
    end
  end

  new_real_words
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

def remove_duplicates(new_real_words)
  distinct_words = []
  new_real_words.each do |word|
    distinct_words << word if !distinct_words.include?(word)
  end

  distinct_words
end
