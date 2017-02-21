class DummyClass

  def a_public_instance_method(arg)
    puts "a_public_instance_method_arg: #{arg}"
  end

  protected

  def a_protected_instance_method(arg)
    puts "a_protected_instance_method_arg: #{arg}"
  end

  private

  def a_private_instance_method(arg)
    puts "a_private_instance_method_arg: #{arg}"
  end

  class << self

    def a_public_singleton_method(arg)
      puts "a_public_singleton_method_arg: #{arg}"
    end

    protected

    def a_protected_singleton_method(arg)
      puts "a_protected_singleton_method_arg: #{arg}"
    end

    private

    def a_private_singleton_method(arg)
      puts "a_private_singleton_method_arg: #{arg}"
    end

  end

end

MethodDecorator.decorate DummyClass, :a_public_instance_method do |*args, &block|
  puts :a_decorated_public_instance_method
  MethodDecorator.call_original_method self, :a_public_instance_method, *args, &block
end

MethodDecorator.decorate DummyClass, :a_protected_instance_method do |*args, &block|
  puts :a_decorated_protected_instance_method
  MethodDecorator.call_original_method self, :a_protected_instance_method, *args, &block
end

MethodDecorator.decorate DummyClass, :a_private_instance_method do |*args, &block|
  puts :a_decorated_private_instance_method
  MethodDecorator.call_original_method self, :a_private_instance_method, *args, &block
end

MethodDecorator.decorate DummyClass.singleton_class, :a_public_singleton_method do |*args, &block|
  puts :a_decorated_public_singleton_method
  MethodDecorator.call_original_method self, :a_public_singleton_method, *args, &block
end

MethodDecorator.decorate DummyClass.singleton_class, :a_protected_singleton_method do |*args, &block|
  puts :a_decorated_protected_singleton_method
  MethodDecorator.call_original_method self, :a_protected_singleton_method, *args, &block
end

MethodDecorator.decorate DummyClass.singleton_class, :a_private_singleton_method do |*args, &block|
  puts :a_decorated_private_singleton_method
  MethodDecorator.call_original_method self, :a_private_singleton_method, *args, &block
end