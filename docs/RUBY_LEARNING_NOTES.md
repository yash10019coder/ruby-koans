# Ruby Learning Notes

Short corrections based on the koan work in this repository. Use this as an
overview; the detailed file-by-file notes are linked below.

- [Assertions](RUBY_ASSERTS_NOTES.md)
- [Truth and falsehood](RUBY_TRUE_FALSE_NOTES.md)
- [Arrays](RUBY_ARRAYS_NOTES.md)
- [Array assignment](RUBY_ARRAY_ASSIGNMENT_NOTES.md)
- [Blocks](RUBY_BLOCKS_CHEAT_SHEET.md)
- [Strings](RUBY_STRINGS_NOTES.md)
- [Symbols](RUBY_SYMBOLS_NOTES.md)
- [Classes and class methods](RUBY_CLASS_METHODS_NOTES.md)
- [Classes (objects, instance variables, accessors, initialize)](RUBY_CLASSES_NOTES.md)
- [Constants (scoping, lookup, inheritance)](RUBY_CONSTANTS_NOTES.md)
- [Exceptions (hierarchy, raising, rescuing, custom exceptions)](RUBY_EXCEPTIONS_NOTES.md)
- [Hashes (keys, values, access, defaults, the mutable default trap)](RUBY_HASHES_NOTES.md)
- [Dice Project (practical class exercise)](RUBY_DICE_PROJECT_NOTES.md)

## Strings: `+`, `+=`, and `<<`

`+` creates a new string and leaves both operands unchanged. `+=` reassigns the
variable to a new string; it does not mutate the original object. `<<` mutates
the string object itself, so another variable pointing to that object sees the
change.

```ruby
original = "Hi"
copy = original
copy += "!" # original is still "Hi"
copy = original
copy << "!" # original is now "Hi!"
```

Use `object_id` when the question is about identity, and `==` when the question
is about value. `equal?` checks identity; `eql?` checks equality suitable for
hash keys.

## Strings: quoting and characters

Double quotes interpret escapes such as `\n` and interpolate `#{value}`.
Single quotes treat most backslashes literally; they only give special meaning
to `\\` and `\'`. A double-quoted string can contain `'` directly, while a
single-quoted string needs an escaped apostrophe.

In modern Ruby, `string[1]` returns a one-character string. Ruby 1.8 returned
the character code integer instead. A multiline literal contains the newline
characters that its syntax places in the text, so count the actual newlines.

## Arrays and ranges

`array[start, length]` means “take this many elements.” `array[start..finish]`
means “slice using these indexes,” with an inclusive end; `...` excludes the
end. `array[2..-1]` has array-index rules, so `-1` means the last element.
That is different from `(2..-1).to_a`, which tries to enumerate a numeric range.

## Blocks, Procs, and lambdas

A block is code attached to a method call; it is not a standalone value. `yield`
runs the attached block. `&block` captures it as a `Proc`, while `&callable`
passes a Proc or lambda as a method's block.

A lambda is an object, so call it with `.call`, `[]`, or `.()`. `add_one(10)`
is not ordinary syntax for calling a lambda stored in a local variable; Ruby
interprets that form as a method call.

Blocks can change an existing local variable from the surrounding scope. A
block-local variable uses the semicolon form, such as `|; temporary|`.

## Symbols

A symbol is an immutable identifier object, not an “immutable string.” It does
not have normal string operations such as `reverse` or `each_char`. Convert it
to a string for text operations, then convert back with `to_sym` if needed.

```ruby
("cats" + "dogs").to_sym # :catsdogs
```

Symbols with spaces are valid when quoted: `:"cats and dogs"`. Replacing spaces
with underscores creates a different symbol; it is not required for validity.

Ruby uses symbols for many names, such as method identifiers, but a constant
like `Dog` refers to a class object. The class object is not itself a symbol.

Modern Ruby can garbage-collect dynamically created symbols. Avoid creating
unnecessary symbols, but do not use the old rule that every symbol lives until
the process ends.

## Classes and class methods

An instance such as `Dog.new` is an object. `Dog` is also an object, and its
class is `Class`; therefore `Dog.is_a?(Class)` and `Dog.is_a?(Object)` are true.

An instance method belongs to objects created from the class. A class method
belongs to the class object itself. A singleton method added to `fido` belongs
only to that one object; `rover` does not receive it.

Instance variables also belong to individual objects. `fido`'s `@name` and
`Dog`'s `@name` are different variables even when both objects use the name
`@name`.

Inside a class statement, `self` is the class object, not a newly created
instance. That is why `def self.method_name` defines a class method.

## Exceptions and `assert_raise`

An exception is an object describing an error or unusual control flow. A
missing method raises `NoMethodError`; it does not raise the object that failed.

`assert_raise` expects the exception class to expect, followed by the code that
should fail. In the singleton-method koan, the expected class is
`NoMethodError`, because `rover.wag` is undefined for `rover`.

## `respond_to?`

`object.respond_to?(:method_name)` asks whether the object can receive that
public method. It returns `true` or `false`, and the question mark is part of
the method name.

By default, private and protected methods are excluded. Passing `true` as the
second argument includes them in the check. `respond_to?` checks capability, not
whether the method will produce a particular result.
