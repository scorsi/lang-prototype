class AwesomeClass < AwesomeObject
  attr_reader :runtime_methods

  def initialize(runtime_class = nil)
    @runtime_class = runtime_class
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
