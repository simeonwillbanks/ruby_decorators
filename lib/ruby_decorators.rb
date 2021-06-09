require "ruby_decorators/version"
require "ruby_decorator"

module RubyDecorators
  class Stack
    def self.all
      @all ||= []
    end
  end

  module DecoratorHelperMethods

    private

    def resolve_method(method_name, args, klass:, &blk)
      decorators = nil
      method = nil
      klass.ancestors.each do |klass|

        decorators = klass.instance_variable_get(:@decorators)[method_name]
        method = klass.instance_variable_get(:@methods)[method_name]

        if !method.nil?
          break
        end
      end

      decorators.inject(method.bind(self)) do |method, decorator|
        decorator = decorator.new if decorator.respond_to?(:new)
        lambda { |*a, &b| decorator.call(method, *a, &b) }
      end.call(*args, &blk)
    end
  end

  def self.extended(klass)
    klass.include(DecoratorHelperMethods)
  end

  def method_added(method_name)
    super

    @methods    ||= {}
    @decorators ||= {}

    return if RubyDecorators::Stack.all.empty?

    @methods[method_name]    = instance_method(method_name)

    RubyDecorators::Stack.all.tap do |a|
      @decorators[method_name] = a.clone
    end.clear

    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      #{method_visibility_for(method_name)}
      def #{method_name}(*args, &blk)
        resolve_method(:#{method_name}, args, klass: #{self}, &blk)
      end
    RUBY_EVAL
  end

  def included(klass)
    decorators = klass.instance_variable_get(:@decorators)
    if decorators.nil?
      decorators = {}
      klass.instance_variable_set(:@decorators, decorators)
    end
    decorators.merge!(@decorators)
    methods = klass.instance_variable_get(:@methods)
    if methods.nil?
      methods = {}
      klass.instance_variable_set(:@methods, methods)
    end
    methods.merge!(@methods)
  end

  private

  def method_visibility_for(method_name)
    if private_method_defined?(method_name)
      :private
    elsif protected_method_defined?(method_name)
      :protected
    else
      :public
    end
  end
end
