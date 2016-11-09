class SomeClass

  class << self

    def some_method(some_arg)
      puts some_arg
    end

  end

  def some_method(some_arg)
    puts some_arg
  end

end

[SomeClass, SomeClass.singleton_class].each do |target_class|
  MethodDecorator.decorate target_class, :some_method do |*args, &block|
    puts :decorated_some_method
    MethodDecorator.call_original self, :some_method, *args, &block
  end
end