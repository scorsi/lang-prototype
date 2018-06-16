class AwesomeObject
  attr_accessor :runtime_class, :ruby_value

  def initialize(runtime_class, ruby_value = self)
    @runtime_class = runtime_class
    @ruby_value = ruby_value
  end

  def call(method, arguments = [])
    @runtime_class.lookup(method).call(self, arguments)
  end
end

class AwesomeClass < AwesomeObject
  attr_reader :runtime_methods

  def initialize(runtime_class = nil)
    super(runtime_class)
    @runtime_methods = {}
  end

  def lookup(method_name)
    method = @runtime_methods[method_name]
    raise "Method not found: #{method_name}" if method.nil?
    method
  end

  def def(name, &block)
    @runtime_methods[name.to_s] = block
  end

  def new
    AwesomeObject.new(self)
  end

  def new_with_value(value)
    AwesomeObject.new(self, value)
  end
end

class AwesomeMethod
  def initialize(params, body)
    @params = params
    @body = body
  end

  def call(receiver, arguments)
    context = Context.new(receiver)

    @params.each_with_index do |param, index|
      context.locals[param] = arguments[index]
    end

    @body.eval(context)
  end
end

class Context
  attr_reader :locals, :current_self, :current_class

  def initialize(current_self, current_class = current_self.runtime_class)
    @locals = {}
    @current_self = current_self
    @current_class = current_class
  end
end

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
