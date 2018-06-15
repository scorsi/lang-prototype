const_class = AwesomeClass.new
const_class.runtime_class = const_class

const_object = AwesomeClass.new(const_class)
const_number = AwesomeClass.new(const_class)
const_string = AwesomeClass.new(const_class)
const_true_class = AwesomeClass.new(const_class)
const_false_class = AwesomeClass.new(const_class)
const_nil_class = AwesomeClass.new(const_class)

const_true = const_true_class.new_with_value(true)
const_false = const_false_class.new_with_value(false)
const_nil = const_nil_class.new_with_value(nil)

const_class.def :new do |receiver, _arguments|
  receiver.new
end
const_class.def :new_with_value do |receiver, arguments|
  receiver.new_with_value arguments[0]
end
const_object.def :print do |_receiver, arguments|
  puts arguments.first.ruby_value
  const_nil
end

Constants = {
  'Class' => const_class,
  'Object' => const_object,
  'Number' => const_number,
  'String' => const_string,
  'TrueClass' => const_true_class,
  'FalseClass' => const_false_class,
  'NilClass' => const_nil_class,

  'true' => const_true,
  'false' => const_false,
  'nil' => const_nil
}
RootContext = Context.new(Constants['Object'].new)
