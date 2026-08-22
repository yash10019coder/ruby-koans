# Ruby Inheritance Notes

This matches the ideas in `about_inheritance.rb`.

## What Is Inheritance?

Inheritance is when a class **extends** another class, gaining all of its methods and behavior. The child class inherits from the parent class and can also add or override methods.

```ruby
class Dog
  def bark
    "WOOF"
  end
end

class Chihuahua < Dog
  # Chihuahua now has .bark from Dog
  # Chihuahua can add or override methods
end

chihuahua = Chihuahua.new
chihuahua.bark  # => "WOOF" (inherited from Dog)
```

The `<` operator means "inherits from."

## The Ancestor Chain: `.ancestors`

Every class has a chain of ancestors — the parent, grandparent, and so on, all the way up to `Object` and `BasicObject`.

```ruby
class Dog
end

class Chihuahua < Dog
end

Chihuahua.ancestors
# => [Chihuahua, Dog, Object, BasicObject]
```

**Important:** All classes ultimately inherit from `Object` (and `Object` inherits from `BasicObject`). This is why every object in Ruby has methods like `.class`, `.to_s`, `.inspect`, etc. — they come from `Object`.

### Checking the Ancestor Chain

Use `.ancestors.include?()` to check if a class is in the chain:

```ruby
Chihuahua.ancestors.include?(Dog)     # => true
Chihuahua.ancestors.include?(Object)  # => true
Chihuahua.ancestors.include?(String)  # => false
```

You can also access ancestors by index:

```ruby
ancestors = Chihuahua.ancestors
ancestors[0]  # => Chihuahua
ancestors[1]  # => Dog
ancestors[2]  # => Object
ancestors[3]  # => BasicObject
```

## Inheriting Behavior

When a subclass inherits from a parent class, it automatically has all the parent's methods.

```ruby
class Dog
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def bark
    "WOOF"
  end
end

class Chihuahua < Dog
  # Chihuahua inherits initialize, name, and bark from Dog
end

chico = Chihuahua.new("Chico")
chico.name  # => "Chico" (inherited method)
chico.bark  # => "WOOF" (inherited method)
```

The subclass doesn't need to redefine methods it inherits. They're automatically available.

## Adding New Behavior

A subclass can add methods that the parent doesn't have:

```ruby
class Dog
  def bark
    "WOOF"
  end
end

class Chihuahua < Dog
  def wag
    :happy
  end
end

chico = Chihuahua.new
chico.wag   # => :happy (new method on Chihuahua)

fido = Dog.new
fido.wag    # => NoMethodError (Dog doesn't have wag)
```

The parent class (`Dog`) does not gain the child's methods (`wag`). Inheritance flows downward only.

## Method Overriding

A subclass can **override** a parent's method by defining its own version with the same name:

```ruby
class Dog
  def bark
    "WOOF"
  end
end

class Chihuahua < Dog
  def bark
    "yip"
  end
end

fido = Dog.new
fido.bark  # => "WOOF"

chico = Chihuahua.new
chico.bark  # => "yip"
```

When you call `chico.bark`, Ruby finds the method on `Chihuahua` first and uses that, never looking at `Dog`'s version.

## Calling the Parent's Method with `super`

Sometimes you want to override a method but also call the parent's version first. Use `super`:

```ruby
class Dog
  def bark
    "WOOF"
  end
end

class BullDog < Dog
  def bark
    super + ", GROWL"
  end
end

ralph = BullDog.new
ralph.bark  # => "WOOF, GROWL"
```

`super` automatically passes all arguments to the parent's method, or you can pass specific arguments:

```ruby
def bark
  super + ", GROWL"  # passes no arguments
end

def bark
  super()  # explicitly passes no arguments
end

def bark
  super("custom")  # passes specific argument
end
```

### What `super` Does

1. Looks up the inheritance chain for a method with the same name
2. Calls that parent method
3. Returns the result
4. The current method continues executing after `super`

## Important: `super` Only Works for the Same Method

`super` **does not** work across methods. It only finds the parent's version of the same method name:

```ruby
class Dog
  def bark
    "WOOF"
  end
end

class GreatDane < Dog
  def growl
    super.bark + ", GROWL"  # ERROR!
  end
end

george = GreatDane.new
george.growl  # => NoMethodError
```

**Why?** `super` in `growl` looks for `Dog.growl`, which doesn't exist. It doesn't magically call other methods.

**The fix:** Call the method explicitly:

```ruby
class GreatDane < Dog
  def growl
    bark + ", GROWL"  # calls the bark method
  end
end

george = GreatDane.new
george.growl  # => "WOOF, GROWL"
```

## Method Lookup Order

When you call a method, Ruby searches **up the ancestor chain**:

1. The object's class first
2. The parent class second
3. The grandparent class
4. All the way up to `BasicObject`

The search stops at the first match. This is why overriding works — the child class is checked first.

```ruby
class Animal
  def sound
    "generic sound"
  end
end

class Dog < Animal
  def sound
    "WOOF"  # overrides Animal's version
  end
end

class Chihuahua < Dog
  # no sound method defined here
end

chico = Chihuahua.new
chico.sound  # => "WOOF" (finds it on Dog, stops searching)
```

## Practical Inheritance Example

```ruby
class Vehicle
  attr_reader :speed

  def initialize(speed)
    @speed = speed
  end

  def accelerate
    @speed += 10
  end
end

class Car < Vehicle
  def trunk_open
    "Trunk is open"
  end

  def accelerate
    super  # call parent's accelerate
    "Car accelerating smoothly"
  end
end

class Truck < Vehicle
  def bed_open
    "Bed is open"
  end

  def accelerate
    super  # call parent's accelerate
    "Truck accelerating with power"
  end
end

car = Car.new(50)
truck = Truck.new(30)

car.accelerate      # => "Car accelerating smoothly", speed now 60
truck.accelerate    # => "Truck accelerating with power", speed now 40

car.trunk_open      # => "Trunk is open"
truck.bed_open      # => "Bed is open"
truck.trunk_open    # => NoMethodError (Truck doesn't have this)
```

## Common Inheritance Patterns

### 1. Adding Behavior Without Overriding

```ruby
class Employee
  def initialize(name, salary)
    @name = name
    @salary = salary
  end

  def work
    "Working..."
  end
end

class Manager < Employee
  def manage
    "Managing team..."
  end
end

manager = Manager.new("Alice", 100000)
manager.work      # => "Working..." (inherited)
manager.manage    # => "Managing team..." (new)
```

### 2. Specializing Behavior (Overriding)

```ruby
class Animal
  def move
    "Moving slowly..."
  end
end

class Bird < Animal
  def move
    "Flying..."
  end
end

class Fish < Animal
  def move
    "Swimming..."
  end
end
```

### 3. Extending Behavior with `super`

```ruby
class Document
  def save
    "Saving to disk..."
  end
end

class EncryptedDocument < Document
  def save
    super
    "Encrypting..."
  end
end
```

## Inheritance vs. Composition

Inheritance is best for **"is-a"** relationships:
- A Chihuahua **is-a** Dog
- A Manager **is-an** Employee

For **"has-a"** relationships, use composition (storing an object as an instance variable) instead:

```ruby
# Bad (wrong relationship):
class Engine < Car  # Engine is not a subclass of Car

# Good (composition):
class Car
  def initialize
    @engine = Engine.new
  end
end
```

## Things to Watch Out For

### 1. Modifying Parent After Creating Child

```ruby
class Dog
  def bark
    "WOOF"
  end
end

class Chihuahua < Dog
end

# Later, you modify Dog:
class Dog
  def bark
    "WOOF WOOF"
  end
end

chico = Chihuahua.new
chico.bark  # => "WOOF WOOF" (changes affect the child)
```

Changes to the parent affect all existing children. Use this carefully.

### 2. Single Inheritance Only

Ruby allows a class to inherit from **only one** parent:

```ruby
class Dog < Animal  # OK

class Chihuahua < Dog, Animal  # ERROR! Can't inherit from two classes
```

(Use modules and mixins for multiple inheritance-like behavior — covered in the modules koan.)

## Best Practices

### 1. Use Inheritance for Clear Hierarchies

```ruby
# Good: clear relationship
class Vehicle
end

class Car < Vehicle
end

# Bad: unclear why Shape inherits from Color
class Color
end

class Shape < Color  # confusing!
end
```

### 2. Keep the Hierarchy Shallow

```ruby
# Good: 2-3 levels
class Animal
end

class Dog < Animal
end

class Chihuahua < Dog
end

# Bad: too deep
class Organism < LivingThing < Being < Entity < ...
end
```

Deeply nested hierarchies are hard to understand and maintain.

### 3. Use `super` When Extending, Not Replacing

```ruby
# Good: calls parent's version first
def initialize(name, age)
  super(name)  # call parent's initialize
  @age = age   # add new behavior
end

# Bad: ignores parent's behavior entirely
def initialize(name, age)
  @age = age  # lost the parent's initialization
end
```

### 4. Document Why Inheritance Is Needed

```ruby
# Inheritance here makes sense:
# Bird is-a Animal. It needs all of Animal's methods
# but overrides move() for flying behavior.
class Bird < Animal
  def move
    "Flying..."
  end
end

# This doesn't need inheritance (no overrides, no added methods):
class SpecialString < String
  # doesn't override or add anything
end
```

## Quick Reference

```ruby
# Define inheritance
class Child < Parent
end

# Check ancestor chain
Child.ancestors            # => [Child, Parent, Object, BasicObject]
Child.ancestors.include?(Parent)  # => true

# Call parent method
super               # passes all arguments
super()             # passes no arguments
super(arg1, arg2)   # passes specific arguments

# Method lookup order
# 1. Child class
# 2. Parent class
# 3. Grandparent class
# 4. ... up to BasicObject

# Get parent class
Child.superclass    # => Parent
```

## Mental Model

```
Inheritance hierarchy:

    BasicObject
         |
      Object
         |
      Animal
       /   \
    Dog   Cat
    |
Chihuahua

Method lookup starts at the object's class and goes UP the chain
```

When you call `chihuahua.bark`, Ruby searches:
1. Chihuahua (not found)
2. Dog (found! → "yip" if overridden, or continue)
3. Animal (if not found in Dog)
4. Object (if not found in Animal)
5. BasicObject (if not found in Object)

First match wins. Stop searching.
