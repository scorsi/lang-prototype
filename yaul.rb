#!/usr/bin/env ruby

require './lexer.rb'

if ARGV[0].nil?
  puts 'You have to give the file to read from.'
  return 1
end

def read_file(_filename)
  File.open(ARGV[0], 'r', &:read)
rescue Errno::ENOENT
  puts "Can't open the file."
  nil
end

return 1 if (text = read_file(ARGV[0])).nil?

lexer = Lexer.new
tokens = lexer.tokenize(text)
return 1 if tokens.nil?
puts tokens
