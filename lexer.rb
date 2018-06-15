class Lexer
  def tokenize(code)
    code.chomp!
    tokens = []
    i = 0
    while i < code.size
      chunk = code[i..-1]
      puts chunk
      puts tokens
      if identifier = chunk[/\A([a-z]\w*)/, 1]
        tokens << [:identifier, identifier]
        i += identifier.size
      elsif constant = chunk[/\A([A-Z]\w*)/, 1]
        tokens << [:constant, constant]
        i += constant.size
      elsif number = chunk[/\A([0-9]+)/, 1]
        tokens << [:number, number]
        i += number.size
      elsif string = chunk[/\A"([^"]*)"/, 1]
        tokens << [:string, string]
        i += string.size + 2
      elsif declaration = chunk[/\A(\!)/, 1]
        tokens << [:declaration, "!"]
        i += 1
      elsif left_paren = chunk[/\A(\()/, 1]
        tokens << [:left_paren, "("]
        i += 1
      elsif right_paren = chunk[/\A(\))/, 1]
        tokens << [:right_paren, ")"]
        i += 1
      elsif left_curly_bracket = chunk[/\A({)/, 1]
        tokens << [:left_curly_bracket, "{"]
        i += 1
      elsif right_curly_bracket = chunk[/\A(})/, 1]
        tokens << [:right_curly_bracket, "}"]
        i += 1
      elsif colon = chunk[/\A(:)/, 1]
        tokens << [:colon, ":"]
        i += 1
      elsif comma = chunk[/\A(,)/, 1]
        tokens << [:comma, ","]
        i += 1
      elsif whitespace = chunk[/\A([ \t\n])+/, 1]
        i += whitespace.size
      else
        puts "Error at : \"#{chunk[0..10]}\""
        return nil
      end
    end
    tokens
  end
end
