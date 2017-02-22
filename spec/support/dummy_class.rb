class DummyClass

  def a_public_instance_method(arg)
    puts "a_public_instance_method_arg: #{arg}"
  end

  def another_public_instance_method(arg)
    puts "another_public_instance_method_arg: #{arg}"
  end

  protected

  def a_protected_instance_method(arg)
    puts "a_protected_instance_method_arg: #{arg}"
  end

  def another_protected_instance_method(arg)
    puts "another_protected_instance_method_arg: #{arg}"
  end

  private

  def a_private_instance_method(arg)
    puts "a_private_instance_method_arg: #{arg}"
  end

  class << self

    def a_public_singleton_method(arg)
      puts "a_public_singleton_method_arg: #{arg}"
    end

    def another_public_singleton_method(arg)
      puts "another_public_singleton_method_arg: #{arg}"
    end

    protected

    def a_protected_singleton_method(arg)
      puts "a_protected_singleton_method_arg: #{arg}"
    end

    private

    def a_private_singleton_method(arg)
      puts "a_private_singleton_method_arg: #{arg}"
    end

    include MethodDecorator

    decorate :another_public_singleton_method do
      puts "another_decorated_public_singleton_method_with: #{call_args}"
      call_original
    end

  end

  include MethodDecorator

  decorate :another_public_instance_method do
    puts "another_decorated_public_instance_method_with: #{call_args}"
    call_original
  end

end

MethodDecorator.decorate DummyClass, :a_public_instance_method do
  puts "a_decorated_public_instance_method_with: #{call_args}"
  call_original
end

MethodDecorator.decorate DummyClass, :a_protected_instance_method do
  puts "a_decorated_protected_instance_method_with: #{call_args}"
  call_original
end

MethodDecorator.decorate DummyClass, :another_protected_instance_method do
  puts "another_decorated_protected_instance_method_with: #{call_args}"
  call_original_with :hue
end

MethodDecorator.decorate DummyClass, :a_private_instance_method do
  puts "a_decorated_private_instance_method_with: #{call_args}"
  call_original
end

MethodDecorator.decorate DummyClass.singleton_class, :a_public_singleton_method do
  puts "a_decorated_public_singleton_method_with: #{call_args}"
  call_original
end

MethodDecorator.decorate DummyClass.singleton_class, :a_protected_singleton_method do
  puts "a_decorated_protected_singleton_method_with: #{call_args}"
  call_original
end

MethodDecorator.decorate DummyClass.singleton_class, :a_private_singleton_method do
  puts "a_decorated_private_singleton_method_with: #{call_args}"
  call_original
end