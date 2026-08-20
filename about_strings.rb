require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutStrings < Neo::Koan
  def test_double_quoted_strings_are_strings
    string = "Hello, World"
    assert_equal true, string.is_a?(String)
  end

  def test_single_quoted_strings_are_also_strings
    string = 'Goodbye, World'
    assert_equal true, string.is_a?(String)
  end

  def test_use_single_quotes_to_create_string_with_double_quotes
    string = 'He said, "Go Away."'
    assert_equal 'He said, "Go Away."', string
  end

  def test_use_double_quotes_to_create_strings_with_single_quotes
    string = "Don't"
    assert_equal "Don't", string
  end

  def test_use_backslash_for_those_hard_cases
    a = "He said, \"Don't\""
    b = 'He said, "Don\'t"'
    assert_equal true, a == b
  end

  def test_use_flexible_quoting_to_handle_really_hard_cases
    a = %(flexible quotes can handle both ' and " characters)
    b = %!flexible quotes can handle both ' and " characters!
    c = %{flexible quotes can handle both ' and " characters}
    assert_equal true, a == b
    assert_equal true, a == c
  end

  def test_flexible_quotes_can_handle_multiple_lines
    long_string = %{
It was the best of times,
It was the worst of times.
}
    assert_equal 54, long_string.length # 25 chars in first line 26 in second + 1 newline in the middle  + 1 newline at the very start and 1 new line at the very end = 52 chars in two lines
    assert_equal 3, long_string.lines.count # three lines because of the newline at the very start 
    assert_equal "\n", long_string[0,1] # learning here is that double quotes represnt the newline that's when i gets a single character but if were to use single quotes here which i did earlier then it would have been two characters which would make it false.
  end

  def test_here_documents_can_also_handle_multiple_lines
    long_string = <<EOS
It was the best of times,
It was the worst of times.
EOS
    # it was my mistake to think things are same in ruby there's always a twist
    assert_equal 53, long_string.length # when creating strings with EOS/documents then there is no new line at the very start there fore it's 53 chars here
    assert_equal 2, long_string.lines.count # documents do not add new lines by default here
    assert_equal "I", long_string[0,1] # here the diff is that there is no new line at the start so we get I which I did in the test case previous to this test case which is present above.
  end

  def test_plus_will_concatenate_two_strings
    string = "Hello, " + "World"
    assert_equal "Hello, World", string
  end

  def test_plus_concatenation_will_leave_the_original_strings_unmodified
    hi = "Hello, "
    there = "World"
    string = hi + there
    assert_equal "Hello, ", hi
    assert_equal "World", there
  end

  def test_plus_equals_will_concatenate_to_the_end_of_a_string
    hi = "Hello, "
    there = "World"
    hi += there
    assert_equal "Hello, World", hi
  end

  def test_plus_equals_also_will_leave_the_original_string_unmodified
    original_string = "Hello, " # this remains unmodified since other object is copied when original_string is reassigned to hi.
    hi = original_string
    there = "World"
    hi += there
    assert_equal "Hello, ", original_string # don't know how did the mistake here to add World as well but my above comment is right so let's move forward for now.
  end

  def test_the_shovel_operator_will_also_append_content_to_a_string
    hi = "Hello, "
    there = "World"
    hi << there
    assert_equal "Hello, World", hi
    assert_equal "World", there
  end

  def test_the_shovel_operator_modifies_the_original_string
    original_string = "Hello, " # TODO: now why is this like this? let's check at the end
    hi = original_string
    there = "World"
    hi << there
    assert_equal "Hello, World", original_string

    # THINK ABOUT IT:
    #
    # Ruby programmers tend to favor the shovel operator (<<) over the
    # plus equals operator (+=) when building up strings.  Why? 
    # TODO:(Verify here first Imp!) Because the plus operator takes the string and makes a copy of it memory increases on each op, whereas with  << (shovel) operator same instance is being used.
  end

  def test_double_quoted_string_interpret_escape_characters
    string = "\n"
    assert_equal 1, string.size
  end

  def test_single_quoted_string_do_not_interpret_escape_characters
    string = '\n' # This exact error happend with me at browserstack and nobody knew eventually gaurav helped debug this with me.
    assert_equal 2, string.size
  end

  def test_single_quotes_sometimes_interpret_escape_characters
    string = '\\\'' # TODO (dig deeper) what is sometimes here; we need to know logic behind this.
    assert_equal 2, string.size
    assert_equal "\\'", string
  end

  def test_double_quoted_strings_interpolate_variables
    value = 123
    string = "The value is #{value}"
    assert_equal "The value is 123", string
  end

  def test_single_quoted_strings_do_not_interpolate
    value = 123
    string = 'The value is #{value}'
    assert_equal 'The value is #{value}', string
  end

  def test_any_ruby_expression_may_be_interpolated
    string = "The square root of 5 is #{Math.sqrt(5)}"
    assert_equal "The square root of 5 is 2.23606797749979", string
  end

  def test_you_can_get_a_substring_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal 'let', string[7,3]
    assert_equal 'let', string[7..9] # My bad my bad this is a range and I misunderstood this for a ,  that too a inclusive range and I was writing the answer for sring[7,9]
  end

  def test_you_can_get_a_single_character_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal 'a', string[1]

    # Surprised? 
    # TODO(dig deeper) WHY? Getting single character is easy so what's the catch?
    # I see I think you are telling it below where older ruby versions characters were represented by integers
  end

  in_ruby_version("1.8") do
    def test_in_older_ruby_single_characters_are_represented_by_integers
      assert_equal 97, ?a
      assert_equal true, ?a == 97

      assert_equal 98, ?b == (?a + 1)
    end
  end

  in_ruby_version("1.9", "2", "3") do
    def test_in_modern_ruby_single_characters_are_represented_by_strings
      assert_equal 'a', ?a
      assert_equal false, ?a == 97
    end
  end

  def test_strings_can_be_split
    string = "Sausage Egg Cheese"
    words = string.split #pretty convinient
    assert_equal ["Sausage", "Egg", "Cheese"], words
  end

  def test_strings_can_be_split_with_different_patterns
    string = "the:rain:in:spain"
    words = string.split(/:/) # this split thing is really sick
    assert_equal ["the","rain","in","spain"], words

    # NOTE: Patterns are formed from Regular Expressions.  Ruby has a
    # very powerful Regular Expression library.  We will become
    # enlightened about them soon.
  end

  def test_strings_can_be_joined
    words = ["Now", "is", "the", "time"] 
    assert_equal "Now is the time", words.join(" ") # sick again
  end

  def test_strings_are_unique_objects
    a = "a string"
    b = "a string"

    assert_equal true, a.eql?(b) # content + lenght matching
    assert_equal true, a           == b # we can do a.eql?(b) for content + lenght matching
    assert_equal false, a.object_id == b.object_id # we can do a.equal?(b) for real object  mathcing
    assert_equal false, a.equal?(b) # object matching
  end
end
