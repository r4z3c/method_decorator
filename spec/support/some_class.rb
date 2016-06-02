class SomeClass

  def some_method(some_arg)
    puts some_arg
  end

  include MethodDecorator

  method_to_override = :some_method
  original_method_name = original_method_name_for(method_to_override)
  decorate_method method_to_override do |some_arg|
    puts :decorated_some_method
    send original_method_name, some_arg
  end

  class << self

    def some_method(some_arg)
      puts some_arg
    end

    include MethodDecorator

    method_to_override = :some_method
    original_method_name = original_method_name_for(method_to_override)
    decorate_method method_to_override do |some_arg|
      puts :decorated_some_method
      send original_method_name, some_arg
    end

  end

end