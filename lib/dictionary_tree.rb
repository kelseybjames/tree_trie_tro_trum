class DictionaryTree

  def initialize(dictionary=nil)
    @root = LetterNode.new(nil, 0, [], nil, nil)
    @depth = 0
    @num_letters = 0
    @num_words = 0

    unless dictionary.nil?
      dictionary.each { |word| insert_word(word[0], word[1]) }
    end
  end

  def letter_to_node(letter)
    LetterNode.new(letter, nil, [], nil, nil)
  end

  def num_letters
    @num_letters
  end

  def num_words
    @num_words
  end

  def insert_word(word, definition)
    raise ArgumentError.new("No word provided") unless word
    raise ArgumentError.new("No definition provided") unless definition

    current_letter = letter_to_node(word[0])
    @root.include?(word[0]) ? (current_letter = @root.child_by_letter(word[0])) : (@root.children << current_letter)
    letter = 1
    while letter < word.length
      if current_letter.include?(word[letter])
        next_letter = current_letter.child_by_letter(word[letter])
      else
        next_letter = LetterNode.new(word[letter], letter + 1, [], current_letter, nil)
      end
      current_letter = next_letter
      letter += 1
    end

    current_letter.definition = definition
    @num_words += 1
    @depth = max(@depth, word.length)
  end

  def remove_word

  end

  def root
    @root
  end

  def depth
    @depth
  end
end