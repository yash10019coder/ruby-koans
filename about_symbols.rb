require File.expand_path(File.dirname(__FILE__) + '/neo')

=begin 

What are symbols in Ruby?
Symbols are a special type of object in Ruby that are used to represent names or identifiers. They are similar to strings, but they are immutable and unique. This means that once a symbol is created, it cannot be changed, and there is only one instance of a symbol with a given name in memory. Symbols are often used as keys in hashes, method names, and for other purposes where a unique identifier is needed. They are created by prefixing a name with a colon, like this: :my_symbol.

When we create two symbols with the same name, they will refer to the same object in memory. This is different from strings, where two strings with the same content can be different objects in memory.

=end

class AboutSymbols < Neo::Koan
  def test_symbols_are_symbols
    symbol = :ruby
    assert_equal true, symbol.is_a?(Symbol) # silly mistake here we is_a? is a type checker which returns true if the object is of the given type or a subclass of that type. So here we are checking if symbol is a Symbol or not.
    # what is ? at the end of is_a? method? It's a convention in Ruby to use a question mark at the end of method names that return a boolean value. It indicates that the method is a predicate method, which means it returns true or false based on some condition. In this case, is_a? checks if the object is an instance of the given class or its subclass, and returns true or false accordingly.
    # Does it connect to concept of nullability in any way? Not really, the question mark in method names is just a naming convention in Ruby to indicate that the method returns a boolean value. It doesn't have any direct connection to the concept of nullability. However, it can be used in conjunction with nullability checks, for example, you might have a method like `nil?` that checks if an object is nil and returns true or false.
    # But in javascript it is for nullabiltiy only? 
    # In JavaScript, the question mark is used in a different context. It is used in optional chaining and ternary operators. In optional chaining, it allows you to access properties of an object that may be null or undefined without causing an error. In ternary operators, it is used to create a shorthand for if-else statements. So while the question mark is used in both Ruby and JavaScript, it serves different purposes in each language.
  end

  def test_symbols_can_be_compared
    symbol1 = :a_symbol
    symbol2 = :a_symbol
    symbol3 = :something_else

    assert_equal true, symbol1 == symbol2 # same symbols, in memory they are poiting to the same object so even if we did sym1.eql?  or sym1.equal? both would return true
    assert_equal false, symbol1 == symbol3 # differnt symbols
  end

  def test_identical_symbols_are_a_single_internal_object
    symbol1 = :a_symbol
    symbol2 = :a_symbol

    # this property is unique and worth noting; they both point to the same object in memory 
    # this happens because a symbols is first translated into string and mapped into memory if exists then it is returned else a new symbol is created and mapped into memory and then returned. So if we create two symbols with the same name, they will refer to the same object in memory.

    assert_equal true, symbol1           == symbol2
    assert_equal true, symbol1.object_id == symbol2.object_id
  end

  def test_method_names_become_symbols
    symbols_as_strings = Symbol.all_symbols.map { |x| x.to_s }
    # method names are symbols in ruby.
    # what other things in ruby are symbols? Constants, class names, module names, and instance variable names are also symbols in Ruby. Additionally, keywords in Ruby (like `def`, `class`, `module`, etc.) are also represented as symbols internally.
    # so roughly everything is a symbol in ruby? Not everything, but many things in Ruby are represented as symbols internally. Symbols are used for identifiers, method names, constants, class names, module names, and instance variable names. However, not everything is a symbol. For example, strings, numbers, arrays, and hashes are not symbols. Symbols are primarily used for things that need to be unique and immutable identifiers.
    # what is not a symbol in ruby list everything that is not a symbol in ruby? In Ruby, the following are not symbols:
    # 1. Strings (e.g., "hello", 'world')
    # 2. Numbers (e.g., 42, 3.14)
    # 3. Arrays (e.g., [1, 2, 3])
    # 4. Hashes (e.g., { key: 'value' })
    # 5. Booleans (e.g., true, false)
    # 6. Nil (e.g., nil)
    # 7. Floats (e.g., 3.14)
    # 8. Ranges (e.g., 1..10)
    # 9. Regular expressions (e.g., /pattern/)
    # 10. Objects (e.g., instances of classes)
    # 11. Classes and modules themselves (e.g., String, Array, Enumerable)
    # 12. Methods (e.g., def my_method; end)
    # 13. Blocks and Procs (e.g., Proc.new { |x| x * 2 })
    # 14. Files and IO objects (e.g., File.open('file.txt', 'r'))
    # 15. Symbols themselves (e.g., :my_symbol) are not symbols, but they are a unique type of object in Ruby.
    #
    # In summary, symbols are a specific type of object in Ruby used for identifiers and unique names, while other data types like strings, numbers, arrays, hashes, and various objects are not symbols.


    # What is a symbol in ruby, list down everything that is a symbol in ruby? In Ruby, the following are represented as symbols:
    # 1. Method names (e.g., :my_method)
    # 2. Constants (e.g., :MyConstant)
    # 3. Class names (e.g., :MyClass)
    # 4. Module names (e.g., :MyModule)
    # 5. Instance variable names (e.g., :@my_instance_variable)
    # 6. Keywords (e.g., :def, :class, :module)
    # 7. Symbols themselves (e.g., :my_symbol)
    assert_equal true, symbols_as_strings.include?("test_method_names_become_symbols") # it'll return true as method names are symbols in ruby and we are checking if the method name is present in the list of all symbols or not.
  end

  # TODO: MORE EMPHASIS ON THIS SEEMS VERY IMPORTANT
  # THINK ABOUT IT:
  #
  # Why do we convert the list of symbols to strings and then compare
  # against the string value rather than against symbols?
  # # Because the symbols are unique and immutable and they are not garbage collected, so if we were to create a lot of symbols dynamically then it would lead to memory leak. So it's better to convert them to strings and then compare them.
  # If they are not garbage collected how do they get removed from memory? They don't get removed from memory, they stay in memory until the program ends. So if we create a lot of symbols dynamically then it would lead to memory leak. So it's better to convert them to strings and then compare them.
  # How are symbols fundamentally used in Ruby? They are used as identifiers, keys in hashes, method names, and for other purposes where a unique identifier is needed. They are also used in metaprogramming and reflection.
  #TODO (dig deeper): for big programs and applications keeping everything in memory not seems feasible and efficient how does ruby or others handle this?

  in_ruby_version("mri") do
    RubyConstant = "What is the sound of one hand clapping?"
    #constants are defined with an uppercase letter at the start, whereas strings are smallcase at the start.
    # what is the diff between ruby contatnt and strings? they both seem exactly same to me. The main difference between a Ruby constant and a string is that a constant is a reference to an object, while a string is an object itself. A constant is defined with an uppercase letter and can be assigned to any object, including strings. Once assigned, the value of a constant should not be changed, although Ruby does not enforce this strictly. A string, on the other hand, is a mutable object that can be modified after it is created. In summary, a constant is a reference to an object (which can be a string), while a string is an actual object that can be manipulated.
    
    def test_constants_become_symbols
      all_symbols_as_strings = Symbol.all_symbols.map { |x| x.to_s }

      assert_equal false, all_symbols_as_strings.include?(RubyConstant)
      # WHy is it false here? Because the constant RubyConstant is not a symbol, it is a string. The test is checking if the string representation of the constant is included in the list of all symbols, which it is not. Therefore, the assertion will return false.
      # constants are not symbols that's why it's false here
    end
  end

  def test_symbols_can_be_made_from_strings
    string = "catsAndDogs"
    # strings -->> Symbols are created by calling to_sym method on the string object. This will return a symbol with the same name as the string.
    # WHy can't we define a symbol like :str_sym = str.to_sym ? Because symbols are not variables, they are a unique type of object in Ruby. You cannot assign a value to a symbol like you can with a variable. Instead, you create a symbol by prefixing a name with a colon, like this: :my_symbol. You can also create a symbol from a string by calling the to_sym method on the string object, which will return a symbol with the same name as the string.
    # Is there a way to seperately see symbols like we have for constants and strings? Not really, symbols are a unique type of object in Ruby and they are not stored in a separate namespace like constants or strings. However, you can get a list of all symbols in Ruby by calling the Symbol.all_symbols method, which will return an array of all symbols currently in memory.
    # what happens when symbols have spaces bewteen them? Symbols can have spaces in them, but they need to be defined using a different syntax. Instead of using the colon prefix, you can use the :"symbol name" syntax to create a symbol with spaces. For example, :"cats and dogs" would create a symbol with the name "cats and dogs". When you convert a string with spaces to a symbol using to_sym, it will also create a symbol with spaces in the name.
    assert_equal :catsAndDogs, string.to_sym
  end

  def test_symbols_with_spaces_can_be_built
    symbol = :"cats and dogs" # just use quotes around the symbol name to create a symbol with spaces in it. This is because symbols are usually defined with a colon prefix and a name without spaces, but when you use quotes, you can include spaces in the name.
    # can we use single quotes instead of double quotes? Yes, you can use single quotes instead of double quotes to create a symbol with spaces. For example, :'cats and dogs' would also create a symbol with the name "cats and dogs". The choice between single and double quotes is mostly a matter of style and preference, as both will work for creating symbols with spaces.
    assert_equal :cats_and_dogs, symbol.to_s.gsub(" ", "_").to_sym # here we are converting the symbol to string and then replacing the spaces with underscores and then converting it back to symbol. This is because symbols with spaces are not valid in Ruby, so we need to replace the spaces with underscores to create a valid symbol name.

    assert_equal "cats and dogs".to_sym, symbol # here we are converting the string to symbol and then comparing it with the symbol we created earlier. This will return true because both symbols have the same name.
  end

  def test_symbols_with_interpolation_can_be_built
    value = "and"
    symbol = :"cats #{value} dogs" # sick
    # what repository level instruction do see attached to the current workspace right now? 

    assert_equal "cats and dogs".to_sym, symbol
  end

  def test_to_s_is_called_on_interpolated_symbols
    symbol = :cats
    string = "It is raining #{symbol} and dogs."

    assert_equal "It is raining cats and dogs.", string
  end

  def test_symbols_are_not_strings
    symbol = :ruby
    assert_equal false, symbol.is_a?(String)
    assert_equal false, symbol.eql?("ruby")
  end

  def test_symbols_do_not_have_string_methods
    symbol = :not_a_string
    # respond to is used to check if an object responds to a particular method or not. It returns true if the object has the method defined, and false otherwise. In this case, we are checking if the symbol object responds to the each_char and reverse methods, which are string methods. Since symbols do not have string methods, both assertions will return false.
    assert_equal false, symbol.respond_to?(:each_char)
    assert_equal false, symbol.respond_to?(:reverse)
  end

  # It's important to realize that symbols are not "immutable
  # strings", though they are immutable. None of the
  # interesting string operations are available on symbols.
  # we cannot do same operations on symbols as we can do on strings. For example, we cannot concatenate symbols, reverse them, or iterate over their characters. Symbols are primarily used as identifiers and unique names, and they do not have the same methods and operations available to strings.

  def test_symbols_cannot_be_concatenated
    # Exceptions will be pondered further down the path
    assert_raise(NoMethodError) do
      :cats + :dogs
    end
  end

  def test_symbols_can_be_dynamically_created
    assert_equal :catsdogs, ("cats" + "dogs").to_sym
  end

  # THINK ABOUT IT:
  #
  # Why is it not a good idea to dynamically create a lot of symbols?
  # No it's not a good idea to dynamically create a lot of symbols because symbols are not garbage collected in Ruby. Once a symbol is created, it stays in memory for the duration of the program. If you create a large number of symbols dynamically, it can lead to increased memory usage and potential memory leaks, as those symbols will not be removed from memory even if they are no longer needed. This can negatively impact the performance and stability of your application. 

  def test_symbols_cannot_be_concatenated
    # Exceptions will be pondered further down the path
    assert_raise(NoMethodError) do
      :cats + :dogs
    end
  end

  def test_symbols_can_be_dynamically_created
    assert_equal :catsdogs, ("cats" + "dogs").to_sym
  end

  # THINK ABOUT IT:
  #
  # Why is it not a good idea to dynamically create a lot of symbols?
  # Symbols stay in memory for the duration of the program and are not garbage collected. If you create a large number of symbols dynamically, it can lead to increased memory usage and potential memory leaks, as those symbols will not be removed from memory even if they are no longer needed. This can negatively impact the performance and stability of your application.
end
