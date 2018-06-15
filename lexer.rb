class Lexer
  KEYWORDS = %w[def class if true false nil].freeze
  def tokenize(code)
    code.chomp!
    tokens = []
    current_indent = 0
    indent_stack = []
    i = 0
    while i < code.size
      chunk = code[i..-1]
      if identifier = chunk[/\A([a-z]\w*)/, 1]
        tokens << if KEYWORDS.include?(identifier)
                    [identifier.to_sym, identifier]
                  else
                    [:identifier, identifier]
                  end
        i += identifier.size
      elsif constant = chunk[/\A([A-Z]\w*)/, 1]
        tokens << [:constant, constant]
        i += constant.size
      elsif number = chunk[/\A([0-9]+)/, 1]
        tokens << [:number, number.to_i]
        i += number.size
      elsif string = chunk[/\A"([^"]*)"/, 1]
        tokens << [:string, string]
        i += string.size + 2
      elsif indent = chunk[/\A\:\n( +)/m, 1]
        if indent.size <= current_indent
          raise "Bad indent level. Got #{indent.size} indents, " \
                "expected > #{current_indent}"
        end
        current_indent = indent.size
        indent_stack.push(current_indent)
        tokens << [:indent, indent.size]
        i += indent.size + 2
      elsif indent = chunk[/\A\n( *)/m, 1]
        if indent.size == current_indent
          tokens << [:newline, '\n']
        elsif indent.size < current_indent
          while indent.size < current_indent
            indent_stack.pop
            current_indent = indent_stack.last || 0
            tokens << [:dedent, indent.size]
          end
          tokens << [:newline, '\n']
        else
          raise "Missing ':'"
        end
        i += indent.size + 1
      elsif operator = chunk[/\A(\|\||&&|==|!=|<=|>=)/, 1]
        tokens << [operator, operator]
        i += operator.size
      elsif chunk =~ /\A /
        i += 1
      else
        value = chunk[0, 1]
        tokens << [value, value]
        i += 1
      end
    end
    while indent = indent_stack.pop
      tokens << [:dedent, indent_stack.first || 0]
    end
    tokens
  end
end
