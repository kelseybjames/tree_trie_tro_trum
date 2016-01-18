class LetterNode < Struct.new(:letter, :depth, :children, :parent, :definition)

  def include?(letter)
    self.children.each { |child| return true if child.letter == letter}
    false
  end

  def child_by_letter(letter)
    self.children.each { |child| return child if child.letter == letter}
  end
end