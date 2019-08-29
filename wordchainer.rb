require 'set'

class WordChainer
  def initialize(word_list)
    @dictionary = File.readlines(word_list).map(&:chomp).to_set
    @adjacent_words_list = Hash.new { |h, k| h[k] = [] }
  end

  def run(source, target)
    source.downcase! && target.downcase!
    # Array of words to #find_adjacent_words. Begins with the source word, and adds adjacent words as it loops.
    @current_words = [source]
    # Keys are words that have already been searched. Values are the words that were modified to make the keys.
    @all_seen_words = { source => nil }

    # Loop until you've run out of words, or until you've seen the target word.
    until @current_words.empty?  || @all_seen_words.include?(target)
      @current_words = explore_current_words(target)
    end

    if @all_seen_words.include?(target)
      build_path(target)
    else
      "No Path Found!"
    end
  end

  def explore_current_words(target)
    new_current_words = []

    @current_words.each do |current_word| 
      find_adjacent_words(current_word).each do |adjacent_word| 

        if !@all_seen_words.include?(adjacent_word)
          new_current_words << adjacent_word 
          @all_seen_words[adjacent_word] = current_word

          # End loop early if you find the target word
          return new_current_words if adjacent_word == target
        end

      end
    end

    new_current_words
  end

  def find_adjacent_words(test_word)
    return @adjacent_words_list[test_word] if @adjacent_words_list.include?(test_word)
    word_arr = []

    (0...test_word.length).each do |i|
      new_word = test_word.clone
      ("a".."z").each do |char|
        new_word[i] = char

        word_arr << new_word.clone if new_word != test_word && @dictionary.include?(new_word)
      end
    end

    @adjacent_words_list[test_word] = word_arr
    word_arr
  end

  def build_path(target)
    path = []
    word = target

    while word
      path.unshift(word.capitalize)
      word = @all_seen_words[word]
    end

    path
  end
end

word_chainer = WordChainer.new("./dictionary.txt")
puts "\n" + "[Net => Tie] " + word_chainer.run("net", "tie").to_s
puts "\n" + "[Warm => Cold] " + word_chainer.run("WaRm", "cOld").to_s
puts "\n" + "[Mask => Belt] " + word_chainer.run("mask", "belt").to_s
puts "\n" + "[Bath => Soap] " + word_chainer.run("Bath", "Soap").to_s
puts "\n" + "[Goose => Stork] " + word_chainer.run("goose", "stork").to_s
puts "\n" + "[Plant => Snake] " + word_chainer.run("plant", "snake").to_s
puts "\n" + "[Couch => Bench] " + word_chainer.run("couch", "bench").to_s
puts "\n" + "[Octopus => Abdomen] " + word_chainer.run("octopus", "abdomen").to_s
puts "\n"