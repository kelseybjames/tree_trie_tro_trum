class DictionaryTree

  attr_reader :num_letters, :num_words, :root, :depth

  def initialize(dictionary=nil)
    @root = LetterNode.new(nil, 0, [], nil, nil)
    @depth = 0
    @num_letters = 0
    @num_words = 0

    unless dictionary.nil?
      dictionary.each { |word| insert_word(word[0], word[1]) }
    end
  end

  def insert_word(word, definition)
    raise ArgumentError.new("No word provided") unless word
    raise ArgumentError.new("No definition provided") unless definition

    if @root.include?(word[0])
      current_letter = @root.child_by_letter(word[0]) 
    else
      current_letter = LetterNode.new(word[0], 1, [], @root, nil)
      current_letter.depth = 1
      @root.children << current_letter
      @num_letters += 1
    end

    letter = 1
    while letter < word.length
      if current_letter.include?(word[letter])
        next_letter = current_letter.child_by_letter(word[letter])
      else
        next_letter = LetterNode.new(word[letter], letter + 1, [], current_letter, nil)
        current_letter.children << next_letter
        @num_letters += 1
      end
      current_letter = next_letter
      letter += 1
    end

    current_letter.definition = definition
    @num_words += 1
    @depth = [@depth, word.length].max
  end

  def definition_of(word)
    return nil unless word_in_tree?(word)

    current_node = @root
    word.split('').each do |letter|
      current_node = current_node.child_by_letter(letter)
    end
    current_node.definition
  end

  def remove_word(word)
    return nil unless word_in_tree?(word)

    current_node = @root
    nodes_to_check = []
    word.split('').each do |letter|
      next_node = current_node.child_by_letter(letter)
      nodes_to_check << next_node
      current_node = next_node
    end

    nodes_to_check.reverse!

    nodes_to_check[0].definition = nil

    nodes_to_check.each do |node|
      if (node.children.length >= 1) || (!node.definition.nil?)
        break
      else
        node.parent.children.delete(node)
        node = nil
        @num_letters -= 1
      end
    end
    @depth = current_depth
    @num_words -= 1
  end

  def current_depth
    depth = 0
    current_node = @root
    while current_node.children.length > 0
      current_node.children.each do |child|
        depth = [depth, child.depth].max
        current_node = child
      end
    end
    depth
  end

  def word_in_tree?(word)
    current_node = @root
    word.split('').each do |letter|
      if current_node.include?(letter)
        current_node = current_node.child_by_letter(letter)
      else
        return false
      end
    end
    true
  end

end

