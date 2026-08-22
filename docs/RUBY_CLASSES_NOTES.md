# Ruby Classes & Objects Notes

This matches the ideas in `about_classes.rb`.

## The Core Concept: Objects, Classes, and Instance Variables

A **class** defines a blueprint. An **object** (or instance) is created from that blueprint using `.new`. Instance variables (`@name`) store data specific to each object.

```ruby
class Dog
end

fido = Dog.new  # fido is an object/instance of the Dog class
fido.class      # => Dog
```

## Instance Variables: Created on First Assignment

Ruby does **not pre-declare** instance variables. They don't exist until you assign to them:

```ruby
class Dog
  def set_name(a_name)
    @name = a_name   # @name is created only when this line runs
  end
end

fido = Dog.new
fido.instance_variables  # => [] — nothing assigned yet

fido.set_name("Fido")
fido.instance_variables  # => [:@name] — now it exists
```

**Key insight:** Reading an unassigned instance variable returns `nil` (with a warning), but that does not create the variable. Only assignment creates it:

```ruby
class Dog
  def check_name
    @name   # reading returns nil, but doesn't create @name
  end
end

dog = Dog.new
dog.check_name          # => nil
dog.instance_variables  # => [] — still empty
```

## Instance Variables Are Private (by default)

Instance variables are encapsulated — they belong to the object, not the outside world. You cannot access `@name` directly from outside the class:

```ruby
class Dog
  def set_name(a_name)
    @name = a_name
  end
end

fido = Dog.new
fido.set_name("Fido")

fido.@name   # => SyntaxError — can't use @ outside a class
fido.name    # => NoMethodError — no method called 'name'
```

## Accessing Instance Variables: Methods Required

To read or write an instance variable from outside, you need **explicit methods**. Ruby provides three levels:

### 1. Manual Getter and Setter Methods

```ruby
class Dog
  def set_name(a_name)
    @name = a_name
  end

  def name
    @name
  end
end

fido = Dog.new
fido.set_name("Fido")
fido.name  # => "Fido"
```

### 2. `attr_reader` — Automatic Getter Only

```ruby
class Dog
  attr_reader :name  # creates def name; @name; end

  def set_name(a_name)
    @name = a_name
  end
end

fido = Dog.new
fido.set_name("Fido")
fido.name          # => "Fido"
fido.name = "Rex"  # => NoMethodError — no setter
```

### 3. `attr_accessor` — Automatic Getter and Setter

```ruby
class Dog
  attr_accessor :name  # creates both def name and def name=(value)
end

fido = Dog.new
fido.name = "Fido"  # calls the setter
fido.name           # => "Fido" — calls the getter
```

## `initialize` — The Constructor

The `initialize` method is special. It runs automatically when you call `.new`, before the new object is returned:

```ruby
class Dog
  attr_reader :name

  def initialize(initial_name)  # runs automatically during Dog.new("Fido")
    @name = initial_name
  end
end

fido = Dog.new("Fido")
fido.name  # => "Fido"
```

**Important:** The arguments to `.new` must match the parameters to `initialize`. If they don't, Ruby raises `ArgumentError`:

```ruby
class Dog
  def initialize(name)
  end
end

Dog.new           # => ArgumentError: wrong number of arguments (given 0, expected 1)
Dog.new("Fido")   # => works
```

## Each Object Has Its Own Instance Variables

Instance variables are per-object. Two objects of the same class do not share instance variables:

```ruby
class Dog
  attr_reader :name
  def initialize(n)
    @name = n
  end
end

fido = Dog.new("Fido")
rover = Dog.new("Rover")

fido.name   # => "Fido"
rover.name  # => "Rover"
```

## `self` — The Current Object

Inside an instance method, `self` refers to the object that received the method call:

```ruby
class Dog
  def get_self
    self
  end
end

fido = Dog.new
fido.get_self == fido  # => true
```

## String Representations: `to_s` and `inspect`

Every object responds to `to_s` and `inspect`. The default implementations are generic, but you can override them:

### `to_s` — Human-Readable

```ruby
class Dog
  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end
end

fido = Dog.new("Fido")
fido.to_s           # => "Fido"
"My dog is #{fido}" # => "My dog is Fido" — automatically calls to_s
```

### `inspect` — Debug-Oriented

```ruby
class Dog
  def inspect
    "<Dog named '#{@name}'>"
  end
end

fido = Dog.new("Fido")
fido.inspect  # => "<Dog named 'Fido'>"
```

**For built-in types like String and Array:**
- `to_s` and `inspect` may return different values
- For a string, `"Fido".to_s == "Fido"` but `"Fido".inspect == "\"Fido\""`
- String interpolation always calls `to_s`, not `inspect`

## Accessing Instance Variables Directly (Advanced)

Ruby provides two low-level tools for getting at private data. Use these sparingly:

```ruby
class Dog
  def initialize(name)
    @name = name
  end
end

fido = Dog.new("Fido")

# Get value by variable name (string or symbol)
fido.instance_variable_get("@name")  # => "Fido"
fido.instance_variable_get(:@name)   # => "Fido"

# Evaluate code in the context of the object (string or block)
fido.instance_eval("@name")          # => "Fido"
fido.instance_eval { @name }         # => "Fido"
```

These bypass encapsulation and are mainly for debugging or metaprogramming.

## Common Class Patterns

### Complete Example: Full Class Definition

```ruby
class Dog
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def bark
    "#{@name} says woof!"
  end

  def to_s
    @name
  end

  def inspect
    "<Dog named #{@name}>"
  end
end

fido = Dog.new("Fido")
fido.bark           # => "Fido says woof!"
puts fido           # prints "Fido" (calls to_s)
p fido              # prints "<Dog named Fido>" (calls inspect)
```

## Quick Reference

| Concept | Syntax | Notes |
| --- | --- | --- |
| Define a class | `class ClassName; end` | Capitalize the class name |
| Create an object | `ClassName.new` | Calls `initialize` automatically |
| Instance variable | `@name` | Exists only per-object, after assignment |
| Getter method | `def name; @name; end` | Or use `attr_reader :name` |
| Setter method | `def name=(val); @name = val; end` | Or use `attr_accessor :name` |
| Constructor | `def initialize(args); end` | Runs during `.new` |
| Current object | `self` | Inside an instance method |
| String form | `def to_s; ...; end` | Used by `puts` and `#{}` |
| Debug form | `def inspect; ...; end` | Used by `p` |
| Access private var | `obj.instance_variable_get(:@name)` | Low-level, use sparingly |
