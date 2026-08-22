# Ruby Exceptions Notes

This matches the ideas in `about_exceptions.rb`.

## What Is an Exception?

An exception is an object that represents an error or unusual situation. When something goes wrong (or you want to signal an error), you **raise** an exception. Code can **rescue** (catch) it to handle the error gracefully.

```ruby
begin
  result = 10 / 0  # This raises ZeroDivisionError
rescue ZeroDivisionError => ex
  puts "Can't divide by zero! Error: #{ex.message}"
end
```

Without the `rescue`, the exception would crash the program. With it, you handle the error and continue.

## The Exception Hierarchy

All exceptions inherit from a chain of classes:

```
Exception (base of everything)
├── StandardError (everyday errors — RESCUE THESE)
│   ├── ArgumentError (wrong number/type of arguments)
│   ├── NoMethodError (calling undefined method)
│   ├── RuntimeError (generic error)
│   ├── ZeroDivisionError (dividing by zero)
│   ├── TypeError (wrong type)
│   ├── NameError (undefined variable/constant)
│   ├── IndexError / KeyError (bad array/hash access)
│   ├── IOError (file/input output problems)
│   └── ... (many others)
├── SystemExit (process exit)
├── NoMemoryError (out of memory)
└── Interrupt (Ctrl+C interrupt)
```

**Critical rule:** Always `rescue StandardError` (or specific subclasses), **never bare `rescue Exception`** unless you absolutely know what you're doing. The base `Exception` class includes system-level errors you can't recover from.

```ruby
# Good: catches most everyday errors
begin
  risky_operation
rescue StandardError => ex
  handle_error(ex)
end

# Dangerous: catches system-level errors you can't handle
begin
  risky_operation
rescue Exception => ex
  # might catch SystemExit, NoMemoryError, Interrupt — not recoverable
end
```

## Creating Custom Exceptions

Define a custom exception by inheriting from `StandardError` (or a subclass):

```ruby
class MySpecialError < RuntimeError
end

class ValidationError < StandardError
end
```

The ancestor chain includes all parent classes:

```ruby
class MySpecialError < RuntimeError
end

MySpecialError.ancestors
# => [MySpecialError, RuntimeError, StandardError, Exception, Object, BasicObject]
```

Why this matters: `rescue` checks the entire chain. If you raise `MySpecialError`, all of these rescue clauses will catch it:

```ruby
raise MySpecialError, "oops"

# All of these work:
rescue MySpecialError        # most specific
rescue RuntimeError          # parent class
rescue StandardError         # grandparent class
rescue Exception             # top-level (too broad)
```

## The `.ancestors` Method

`.ancestors` returns an array of all classes and modules in the inheritance chain, from most specific to most general:

```ruby
MySpecialError.ancestors
# => [MySpecialError, RuntimeError, StandardError, Exception, Object, BasicObject]

# Index access:
ancestors = MySpecialError.ancestors
ancestors[0]  # => MySpecialError
ancestors[1]  # => RuntimeError
ancestors[2]  # => StandardError
ancestors[3]  # => Exception
ancestors[4]  # => Object
ancestors[5]  # => BasicObject
```

This is why the koan asks for `ancestors[1]`, `ancestors[2]`, etc. — it's verifying the inheritance chain is correct.

## Raising Exceptions

Use `raise` to signal an error:

```ruby
# Raise with a message (becomes RuntimeError by default)
raise "Something went wrong"

# Raise a specific exception type with a message
raise ArgumentError, "age must be a number"
raise MySpecialError, "invalid user data"

# Raise with a custom exception object
raise MySpecialError.new("detailed error message")

# Re-raise the current exception in a rescue block
begin
  risky_operation
rescue StandardError => ex
  log_error(ex)
  raise  # re-raises the same exception
end
```

**Note:** `fail` and `raise` are synonyms. Both work identically; `raise` is more common.

## Catching Exceptions: `begin...rescue...end`

```ruby
begin
  # Code that might raise an exception
  result = risky_operation
rescue ArgumentError => ex
  # Handle ArgumentError specifically
  puts "Invalid argument: #{ex.message}"
rescue ZeroDivisionError => ex
  # Handle ZeroDivisionError specifically
  puts "Cannot divide by zero"
rescue StandardError => ex
  # Handle any other StandardError
  puts "Unexpected error: #{ex.message}"
ensure
  # This always runs, even if no exception was raised
  cleanup_resources
end
```

### Multiple Exception Types in One `rescue`

```ruby
begin
  risky_operation
rescue ArgumentError, TypeError, ZeroDivisionError => ex
  # Catches any of these three types
  puts "Caught: #{ex.class}"
rescue StandardError => ex
  # Catches other StandardErrors
  puts "Other error: #{ex.message}"
end
```

### The `=> variable` Binding

The `=> variable` captures the exception object so you can inspect it:

```ruby
begin
  raise ArgumentError, "invalid input"
rescue ArgumentError => ex
  ex.class      # => ArgumentError
  ex.message    # => "invalid input"
  ex.backtrace  # => array of file:line locations
end
```

Without the binding, you can't access the exception:

```ruby
begin
  raise ArgumentError, "invalid input"
rescue ArgumentError
  # ex is not defined here
end
```

## Exception Methods

Every exception object has these useful methods:

```ruby
begin
  raise ArgumentError, "age must be positive"
rescue ArgumentError => ex
  ex.message      # => "age must be positive"
  ex.class        # => ArgumentError
  ex.backtrace    # => ["/file.rb:10:in `test'", "/file.rb:5:in `<main>'", ...]
  ex.to_s         # => "age must be positive"
  ex.inspect      # => "#<ArgumentError: age must be positive>"
end
```

## The `ensure` Clause

`ensure` runs **no matter what** — whether an exception was raised or not:

```ruby
def open_file(filename)
  file = File.open(filename)
  begin
    process_file(file)
  rescue IOError => ex
    puts "File error: #{ex.message}"
  ensure
    file.close  # always runs, even if process_file raises
  end
end
```

Without `ensure`, if an exception is raised, cleanup code might be skipped:

```ruby
# Bad: file might not close if process_file raises
file = File.open(filename)
process_file(file)
file.close

# Good: file always closes
file = File.open(filename)
begin
  process_file(file)
ensure
  file.close
end
```

## Testing Exceptions: `assert_raise`

In tests, use `assert_raise` to verify that code raises the expected exception:

```ruby
assert_raise(ArgumentError) do
  Dog.new  # if initialize requires an argument but we pass none
end

assert_raise(NoMethodError) do
  object.undefined_method
end

assert_raise(ZeroDivisionError) do
  10 / 0
end
```

If the exception is not raised, the test fails. If a different exception is raised, the test also fails.

## Common Exception Scenarios

| Scenario | Exception | What to Do |
| --- | --- | --- |
| Calling undefined method | `NoMethodError` | Check method name, or define it |
| Wrong number of arguments | `ArgumentError` | Check argument count |
| Dividing by zero | `ZeroDivisionError` | Check denominator |
| Wrong type passed | `TypeError` | Convert or validate type |
| Undefined variable/constant | `NameError` | Check spelling |
| Invalid array index | Returns `nil` (not an error!) | Check if `nil` before using |
| File not found | `Errno::ENOENT` (IOError) | Check file path |

**Important:** Array and hash access don't raise exceptions for missing keys:

```ruby
array = [1, 2, 3]
array[99]           # => nil (not an error)
array[99].upcase    # => NoMethodError (because nil has no upcase method)

hash = {a: 1}
hash[:missing]      # => nil (not an error)
hash[:missing].upcase  # => NoMethodError
```

## Exception Hierarchy: Why It Matters

The inheritance chain determines what `rescue` catches:

```ruby
class MySpecialError < RuntimeError
end

begin
  raise MySpecialError, "oops"
rescue RuntimeError
  # Catches MySpecialError because RuntimeError is MySpecialError's parent
end

begin
  raise MySpecialError, "oops"
rescue StandardError
  # Catches MySpecialError because StandardError is in the ancestor chain
end
```

This is why you can use general `rescue` clauses and still catch your custom errors.

## Best Practices

### 1. Raise Specific Exceptions

```ruby
# Good: specific exception type
raise ArgumentError, "age must be positive" if age < 0

# Bad: generic RuntimeError
raise "age must be positive" if age < 0
```

### 2. Rescue Specific Exceptions

```ruby
# Good: catch what you know how to handle
begin
  age = Integer(user_input)
rescue ArgumentError
  puts "Please enter a valid number"
end

# Bad: catch everything (masking real bugs)
begin
  age = Integer(user_input)
rescue StandardError
  puts "Something went wrong"
end
```

### 3. Use `ensure` for Cleanup

```ruby
# Good: guaranteed cleanup
begin
  file = File.open(filename)
  process_file(file)
ensure
  file.close
end

# Bad: cleanup might be skipped on error
file = File.open(filename)
process_file(file)
file.close
```

### 4. Create Custom Exceptions for Your Domain

```ruby
# Good: domain-specific errors
class ValidationError < StandardError; end
class NotFoundError < StandardError; end
class AuthenticationError < StandardError; end

def find_user(id)
  raise NotFoundError, "User #{id} not found" unless user_exists?(id)
end

# Bad: generic RuntimeError everywhere
def find_user(id)
  raise RuntimeError, "User not found" unless user_exists?(id)
end
```

## Quick Reference

| Concept | Syntax | Example |
| --- | --- | --- |
| Raise exception | `raise ExceptionClass, "message"` | `raise ArgumentError, "invalid"` |
| Catch exception | `rescue ExceptionClass => var` | `rescue ArgumentError => ex` |
| Always cleanup | `ensure` block | `ensure { file.close }` |
| Get message | `exception.message` | `ex.message` |
| Get type | `exception.class` | `ex.class` |
| Get trace | `exception.backtrace` | `ex.backtrace` |
| Test exception | `assert_raise(Class)` | `assert_raise(ArgumentError) { ... }` |
| View ancestors | `MyClass.ancestors` | `MyError.ancestors` |
| Catch multiple | `rescue Error1, Error2` | `rescue ArgError, TypeError` |

## Mental Model

```
Raising an exception:

raise MySpecialError, "details"
    |
    +-- Creates an exception object
    +-- Stops normal execution
    +-- Jumps to the nearest rescue block

Catching an exception:

begin
  ...
rescue RuntimeError => ex  # checks if exception.is_a?(RuntimeError)
  ...                       # by looking at .ancestors
end
```
