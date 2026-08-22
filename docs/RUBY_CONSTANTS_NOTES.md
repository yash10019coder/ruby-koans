# Ruby Constants Notes

This matches the ideas in `about_constants.rb`.

## What Are Constants?

Constants are identifiers that begin with a **capital letter**. By convention, they hold values that should not change. Ruby does not prevent reassignment, but warns you if you change one:

```ruby
PI = 3.14159
PI = 3.14  # => warning: already initialized constant PI
```

## Lexical Scope vs. Global Scope

Constants are looked up differently from regular variables. Ruby checks **lexical scope** (where you are) first, then inheritance.

### Top-Level Constants (Global Scope)

A constant defined outside any class or module is at the **top level**:

```ruby
GLOBAL_CONST = "top level"
```

To explicitly reference a top-level constant from anywhere, use the `::` prefix:

```ruby
::GLOBAL_CONST  # "top level"
```

The `::` means "start the lookup at the top-level namespace."

## Nested Constants (Class Scope)

Constants defined inside a class are **scoped to that class**:

```ruby
class MyClass
  CLASS_CONST = "inside class"
end

MyClass::CLASS_CONST  # => "inside class"
::MyClass::CLASS_CONST  # => "inside class" (explicit top-level start)
```

## Constant Lookup: Lexical Scope Wins

When looking up a constant inside a method, Ruby first checks the **lexical scope** (the class/module where the code was written), then inheritance.

```ruby
class Animal
  LEGS = 4

  def count_legs
    LEGS  # looks in Animal first, then parent classes
  end
end

class Dog < Animal
  def count_legs
    LEGS  # still finds Animal::LEGS = 4
  end
end

Dog.new.count_legs  # => 4
```

## Lexical Scope vs. Inheritance Hierarchy

When a class is defined **inside** a block, it has access to that block's constants. When a class is defined **outside**, it does not:

### Case 1: Class Defined Inside a Block

```ruby
class MyAnimals
  LEGS = 2

  class Bird < Animal
    def legs_in_bird
      LEGS  # looks in MyAnimals scope first
    end
  end
end

MyAnimals::Bird.new.legs_in_bird  # => 2
# Bird inherits from Animal (which has LEGS = 4),
# but lexical scope (MyAnimals) wins
```

**Why:** `Bird` is defined inside the `class MyAnimals { ... }` block, so its lexical scope includes `MyAnimals::LEGS`.

### Case 2: Class Defined Using Nested Scope Resolution (`::`)

```ruby
class MyAnimals
  LEGS = 2
end

class MyAnimals::Oyster < Animal
  def legs_in_oyster
    LEGS  # MyAnimals::LEGS is not in lexical scope
  end
end

MyAnimals::Oyster.new.legs_in_oyster  # => 4
# Oyster inherits from Animal (which has LEGS = 4),
# inheritance hierarchy is used because lexical scope doesn't have LEGS
```

**Why:** `Oyster` is defined outside the `class MyAnimals { ... }` block (using `class MyAnimals::Oyster`), so its lexical scope does not include `MyAnimals::LEGS`. The inheritance hierarchy is checked instead.

## Nested Classes Inherit Constants from Enclosing Classes

A class defined inside another class can access the outer class's constants:

```ruby
class Animal
  LEGS = 4

  class NestedAnimal
    def legs
      LEGS  # finds Animal::LEGS
    end
  end
end

Animal::NestedAnimal.new.legs  # => 4
```

## Subclasses Inherit Constants from Parent Classes

A subclass can access constants defined in its parent:

```ruby
class Animal
  LEGS = 4
end

class Reptile < Animal
  def count_legs
    LEGS  # finds Animal::LEGS
  end
end

Reptile.new.count_legs  # => 4
```

## Scope Resolution Operator (`::`): Explicit Lookup

Use `::` to explicitly specify where to look for a constant:

```ruby
C = "top level"

class MyClass
  C = "inside class"

  def get_local
    C  # => "inside class" (lexical scope)
  end

  def get_top_level
    ::C  # => "top level" (explicit top-level)
  end
end

MyClass::C  # => "inside class"
::MyClass::C  # => "inside class" (start at top-level, then look inside MyClass)
```

## The Lookup Order: Step by Step

When Ruby sees `LEGS` in a method:

1. **Check lexical scope** — the class/module where the code was written
2. **Check inheritance hierarchy** — the parent classes
3. **Check top-level** — constants at the top level of the file
4. **Fail** — raise `NameError` if not found

Example:

```ruby
TOP = "top"

class Parent
  PARENT = "parent"

  class Child < Parent
    CHILD = "child"

    def lookup
      CHILD      # => "child" (lexical scope wins)
      PARENT     # => "parent" (found in parent class)
      TOP        # => "top" (found at top-level)
      UNKNOWN    # => NameError (not found)
    end
  end
end
```

## Common Patterns

### Application-Wide Configuration

```ruby
# Define at top-level
MAX_RETRIES = 3
DEFAULT_TIMEOUT = 30

class APIClient
  def initialize
    @retries = MAX_RETRIES     # visible here
    @timeout = DEFAULT_TIMEOUT
  end
end
```

### Enumeration-Like Constants

```ruby
class Status
  PENDING = "pending"
  APPROVED = "approved"
  REJECTED = "rejected"
end

Status::PENDING   # => "pending"
```

### Magic Constants

Ruby provides a few built-in constants:

```ruby
__FILE__      # Current file name
__LINE__      # Current line number
__dir__       # Current directory
RUBY_VERSION  # Ruby version string
```

## Quick Reference

| Syntax | Meaning |
| --- | --- |
| `CONSTANT = value` | Define a constant (at any scope) |
| `ClassName::CONSTANT` | Access constant inside a class |
| `::CONSTANT` | Access top-level constant (explicit) |
| `::ClassName::CONSTANT` | Access constant inside a class (explicit) |
| `CONSTANT` (bare name) | Lookup in lexical scope, then inheritance, then top-level |

## Mental Model

```
Constant lookup:

CONSTANT
   |
   ├─ Check: Am I inside a class/module? Look there first
   ├─ Check: Does my parent class have this?
   ├─ Check: Is this at the top level?
   └─ Fail: NameError

::CONSTANT
   |
   └─ Start at top level, ignore enclosing scopes
```
