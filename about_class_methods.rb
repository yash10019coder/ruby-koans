require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutClassMethods < Neo::Koan
  class Dog
  end
  # objectw are objects created when creating a object of a class.
  # class is a class when directly interpreting
  # classes are objects as well but objects are never class
  # we can easily check this with .is_a?(arg) method where before dot can be class or object and arg can contain any type
  def test_objects_are_objects
    fido = Dog.new
    assert_equal true, fido.is_a?(Object)
  end

  def test_classes_are_classes
    assert_equal true, Dog.is_a?(Class)
  end

  def test_classes_are_objects_too
    assert_equal true, Dog.is_a?(Object)
  end

  def test_objects_have_methods
    fido = Dog.new
    assert fido.methods.size > 0
  end

  def test_classes_have_methods
    assert Dog.methods.size > 0
  end

  def test_you_can_define_methods_on_individual_objects
    fido = Dog.new
    def fido.wag
      :fidos_wag
    end
    assert_equal :fidos_wag, fido.wag
  end

  def test_other_objects_are_not_affected_by_these_singleton_methods
    fido = Dog.new
    rover = Dog.new
    def fido.wag
      :fidos_wag
    end

    assert_raise(NoMethodError) do # instructor wants to throw the no method error here since rover doesn't have the newly added method wag so it will throw an error when calling rover.wag. I got the concept but didn't think of adding the exception here.
      rover.wag
    end
  end

  # ------------------------------------------------------------------

  class Dog2
    def wag
      :instance_level_wag # proper class defined method being called when calling wag with a object of Dog2
    end
  end

  def Dog2.wag
    :class_level_wag # external methods singletons extending/associating with Dog2 without modifying it's behaviour
  end

  def test_since_classes_are_objects_you_can_define_singleton_methods_on_them_too
    assert_equal :class_level_wag, Dog2.wag # external method (singleton_methods)
  end

  def test_class_methods_are_independent_of_instance_methods
    fido = Dog2.new
    assert_equal :instance_level_wag, fido.wag # when calling a object of a class Dog2 it calls instance level method.
    assert_equal :class_level_wag, Dog2.wag # when calling externally since no object is created it refernces a external defined method associating with class Dog2
  end

  # ------------------------------------------------------------------

  class Dog
    attr_accessor :name # can be used as getters + setters for easy calling
  end

  def Dog.name
    @name # instance variabe yielding when Dog.name is getting called
  end

  def test_classes_and_instances_do_not_share_instance_variables
    fido = Dog.new
    fido.name = "Fido"
    assert_equal "Fido", fido.name
    assert_equal nil, Dog.name
  end

  # ------------------------------------------------------------------

  class Dog
    def Dog.a_class_method
      :dogs_class_method
    end
  end

  def test_you_can_define_class_methods_inside_the_class
    assert_equal :dogs_class_method, Dog.a_class_method
  end

  # ------------------------------------------------------------------

  LastExpressionInClassStatement = class Dog
                                     21 # if any value is prsent in the class it'll be returned or value of their last expresssion
                                   end

  def test_class_statements_return_the_value_of_their_last_expression
    assert_equal 21, LastExpressionInClassStatement
  end

  # ------------------------------------------------------------------

  SelfInsideOfClassStatement = class Dog
                                 self # self points to itself which yields Dog
                               end

  def test_self_while_inside_class_is_class_object_not_instance
    assert_equal true, Dog == SelfInsideOfClassStatement
  end

  # ------------------------------------------------------------------

  class Dog
    def self.class_method2 # self points to class which makes class_method2 a method of Dog
      :another_way_to_write_class_methods
    end
  end

  def test_you_can_use_self_instead_of_an_explicit_reference_to_dog
    assert_equal :another_way_to_write_class_methods, Dog.class_method2
  end

  # ------------------------------------------------------------------

  class Dog
    class << self # Self points to Dog
      def another_class_method # this becomes the method of Dog
        :still_another_way
      end
    end
  end

  def test_heres_still_another_way_to_write_class_methods
    assert_equal :still_another_way, Dog.another_class_method
  end

  # THINK ABOUT IT:
  #
  # The two major ways to write class methods are:
  #   class Demo
  #     def self.method
  #     end
  #
  #     class << self
  #       def class_methods
  #       end
  #     end
  #   end
  #
  # Which do you prefer and why?
  # Are there times you might prefer one over the other?

=begin 
  I would prefer first method when I'm calling the methods from objects and second method when I'm calling the methods Directly from class like
  dg = Dog.new
  dg.methods # first way

  Dog.class.class_methods # second way


=end

  # ------------------------------------------------------------------

  def test_heres_an_easy_way_to_call_class_methods_from_instance_methods
    fido = Dog.new
    assert_equal :still_another_way, fido.class.another_class_method
  end

end
