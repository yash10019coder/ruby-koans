# Ruby Classes and Class Methods Notes

This matches the ideas in `about_class_methods.rb`.

`Dog.new` creates an instance. `Dog` is itself an object whose class is
`Class`. An instance method belongs to instances; a class method belongs to the
class object.

A singleton method added to `fido` belongs only to `fido`; another `Dog` object
does not receive it. A missing method raises `NoMethodError`, which is why the
koan uses `assert_raise(NoMethodError)`.

Inside a class statement, `self` is the class object. Therefore `def self.wag`
defines a class method. `fido.class.wag` is one way for an instance method to
reach a class method.

`respond_to?(:name)` checks whether an object can receive a public method.
Passing `true` as the second argument includes private and protected methods.