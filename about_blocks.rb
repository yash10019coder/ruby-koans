require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutBlocks < Neo::Koan
  def method_with_block
    result = yield # yield is a keyword in Ruby that is used to call a block that has been passed to a method. When a method is defined with a block, the yield keyword can be used within the method to execute the block of code that was passed in. In this case, the method_with_block method is defined to take a block, and when it is called, it will execute the block and return the result of that execution.
    result
  end

  def test_methods_can_take_blocks
    yielded_result = method_with_block { 1 + 2 }
    assert_equal 3, yielded_result
  end

  def test_blocks_can_be_defined_with_do_end_too
    yielded_result = method_with_block do 1 + 2 end # do end is another way to define a block in Ruby. It is often used for multi-line blocks, while curly braces {} are typically used for single-line blocks. In this case, the method_with_block method is called with a block defined using do...end syntax, which adds 1 and 2 together and returns the result.
    assert_equal 3, yielded_result
  end

  # ------------------------------------------------------------------

  def method_with_block_arguments
    yield("Jim")
  end

  def test_blocks_can_take_arguments # This test method is checking if blocks can take arguments. It calls the method_with_block_arguments method, which yields the string "Jim" to the block. The block takes one argument, which is assigned the value yielded by the method. The assert_equal statement checks if the argument passed to the block is equal to "Jim". If it is, the test will pass, indicating that blocks can indeed take arguments.
    method_with_block_arguments do |argument|
      assert_equal "Jim", argument
    end
  end

  # ------------------------------------------------------------------

  def many_yields
    yield(:peanut)
    yield(:butter)
    yield(:and)
    yield(:jelly)
  end

  def test_methods_can_call_yield_many_times
    result = []
    many_yields { |item| result << item }
    assert_equal [:peanut, :butter, :and, :jelly], result
  end

  # ------------------------------------------------------------------

  def yield_tester # we can check if there is a block given when calling a method
    if block_given?
      yield
    else
      :no_block
    end
  end

  def test_methods_can_see_if_they_have_been_called_with_a_block
    assert_equal :with_block, yield_tester { :with_block }
    assert_equal :no_block, yield_tester
  end

  # ------------------------------------------------------------------

  def test_block_can_affect_variables_in_the_code_where_they_are_created
    value = :initial_value # scope method level
    method_with_block { value = :modified_in_a_block } # block scope also method level that's why it affects value variable
    assert_equal :modified_in_a_block, value
  end

  def test_blocks_can_be_assigned_to_variables_and_called_explicitly
    add_one = lambda { |n| n + 1 }
    assert_equal 11, add_one.call(10)

    # Alternative calling syntax
    assert_equal 11, add_one[10] # again retarded now why the hell anyone should write this it confuses with arrays
    assert_equal 11, add_one.(10) # at least this makes some sense but why the hell anyone would put a .(10) why don't add_one(10)  end
    # a lambda is an object not a method simple call add_one(10) is reserved for methods and not for objects. So we have to use the call method or the [] or .() syntax to invoke the lambda object with an argument.

  def test_stand_alone_blocks_can_be_passed_to_methods_expecting_blocks
    # this is like passing a apply logic to an existing method which is giving a value let's say method_with_block_arguments returns a square side and then we use a block to calculate the area of the square. So we can pass a block to an existing method to apply some logic on the value returned by that method.
    make_upper = lambda { |n| n.upcase }
    result = method_with_block_arguments(&make_upper)
    assert_equal "JIM", result
  end

  # ------------------------------------------------------------------

  # same thing done explicitly with &block argument in method definition and then calling block.call() instead of yield which makes more sense as we are passing a block to a method and then calling it explicitly instead of using yield which is more implicit and less readable. So it's better to use &block argument in method definition and then calling block.call() instead of yield.
  def method_with_explicit_block(&block)
    block.call(10)
  end

  def test_methods_can_take_an_explicit_block_argument
    assert_equal 20, method_with_explicit_block { |n| n * 2 }

    add_one = lambda { |n| n + 1 }
    assert_equal 11, method_with_explicit_block(&add_one)
  end

end
