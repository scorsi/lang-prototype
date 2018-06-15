require 'test_helper'
require 'lexer'

class LexerTest < Test::Unit::TestCase
  def test_number
    assert_equal [[:number, 1]], Lexer.new.tokenize('1')
  end

  def test_string
    assert_equal [[:string, 'hi']], Lexer.new.tokenize('"hi"')
  end

  def test_indentifier
    assert_equal [[:identifier, 'name']], Lexer.new.tokenize('name')
  end

  def test_constant
    assert_equal [[:constant, 'Name']], Lexer.new.tokenize('Name')
  end

  def test_operator
    assert_equal [['+', '+']], Lexer.new.tokenize('+')
    assert_equal [['||', '||']], Lexer.new.tokenize('||')
  end

  def test_indent
    code = <<-CODE
if 1:
  if 2:
    print("...")
    if false:
      pass
    print("done!")
  2

print "The End"
    CODE
    tokens = [
      [:if, 'if'], [:number, 1],
      [:indent, 2],
      [:if, 'if'], [:number, 2],
      [:indent, 4],
      [:identifier, 'print'], ['(', '('],
      [:string, '...'],
      [')', ')'],
      [:newline, '\n'],
      [:if, 'if'], [:false, 'false'],
      [:indent, 6],
      [:identifier, 'pass'],
      [:dedent, 4], [:newline, '\n'],
      [:identifier, 'print'], ['(', '('],
      [:string, 'done!'],
      [')', ')'],
      [:dedent, 2], [:newline, '\n'],
      [:number, 2], #   2
      [:dedent, 0], [:newline, '\n'],
      [:newline, '\n'],
      [:identifier, 'print'], [:string, 'The End']
    ]
    assert_equal tokens, Lexer.new.tokenize(code)
  end
end
