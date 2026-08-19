require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutArrays < Neo::Koan
  def test_creating_arrays
    empty_array = Array.new
    assert_equal Array, empty_array.class
    assert_equal 0, empty_array.size
  end

  def test_array_literals
    array = Array.new
    assert_equal [], array

    array[0] = 1
    assert_equal [1], array

    array[1] = 2
    assert_equal [1, 2], array

    array << 333
    assert_equal [1,2,333], array
  end

  def test_accessing_array_elements
    array = [:peanut, :butter, :and, :jelly]

    assert_equal :peanut, array[0]
    assert_equal :peanut, array.first
    assert_equal :jelly, array[3]
    assert_equal :jelly, array.last
    assert_equal :jelly, array[-1]
    assert_equal :butter, array[-3]
  end

  def test_slicing_arrays
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut], array[0,1]
    assert_equal [:peanut, :butter], array[0,2]
    assert_equal [:and, :jelly], array[2,2]
    assert_equal [:and, :jelly], array[2,20]
    assert_equal [], array[4,0]
    assert_equal [], array[4,100]
    assert_equal nil, array[5,0] # who the fuck is this phycho to add two rules when slicing arrays, one is that if the starting index is equal to the length of the array, it returns an empty array, but if the starting index is greater than the length of the array, it returns nil. (Retarded, I know, but that's how it is in Ruby)
  end

  def test_arrays_and_ranges
    assert_equal Range, (1..5).class
    assert_not_equal [1,2,3,4,5], (1..5)
    assert_equal [1,2,3,4,5], (1..5).to_a # inclusive range [a,b]
    assert_equal [1,2,3,4], (1...5).to_a # exclusive range [a,b)
  end

  def test_slicing_with_ranges
    array = [:peanut, :butter, :and, :jelly]

    # ranges are here just a represnsation so that we can have both inclusive and exclusive slicing as it's possible with arr[idx1, totSize] but not that much intuitive

    assert_equal [:peanut, :butter, :and], array[0..2] # inclusive range [a,b]     
    assert_equal [:peanut, :butter], array[0...2] # exclusive range [a,b)
    assert_equal [:and, :jelly], array[2..-1] #note here as well since it's just a reprsentation of start index idx1 end index idx2. It'll totally work here but if it were a range and we were converting it to array we would have gotten an empty array []
  end

  def test_pushing_and_popping_arrays
    array = [1,2]
    array.push(:last) # here last is a value so it'll get pushed

    assert_equal [1,2,:last], array

    popped_value = array.pop
    assert_equal :last, popped_value
    assert_equal [1,2], array
  end

  def test_shifting_arrays
    array = [1,2]
    array.unshift(:first) # like push only that it pushes from the start instead of end. Brainfuck

    assert_equal [:first, 1,2], array

    shifted_value = array.shift # removes the first element from the array and returns it. Brainfuck
    assert_equal :first, shifted_value
    assert_equal [1,2], array
  end

end
