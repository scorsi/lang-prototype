require 'test_helper'
require 'vm'

Constants['Number'].def :+ do |receiver, arguments|
  result = receiver.ruby_value + arguments.first.ruby_value
  Constants['Number'].new_with_value(result)
end

class VMTest < Test::Unit::TestCase
  def test_run
    bytecode = [
      PUSH_NUMBER, 1,
      PUSH_NUMBER, 2,
      CALL, '+', 1,
      RETURN
    ]
    result = VM.new.run(bytecode)
    assert_equal 3, result.ruby_value
  end
end
