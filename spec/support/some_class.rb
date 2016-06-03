class SomeClass

  def some_method(some_arg)
    puts some_arg
  end

  include MethodDecorator

  method_to_override = :some_method
  decorate_method method_to_override do |*args|
    puts :decorated_some_method
    call_original_method method_to_override, *args
  end

  class << self

    def some_method(some_arg)
      puts some_arg
    end

    include MethodDecorator

    method_to_override = :some_method
    decorate_method method_to_override do |*args|
      puts :decorated_some_method
      call_original_method method_to_override, *args
    end

  end

end