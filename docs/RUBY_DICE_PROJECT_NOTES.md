# Ruby Dice Project Notes

This matches the ideas in `about_dice_project.rb`.

## Project Overview

The Dice Project is a practical exercise that combines several Ruby class concepts:
- **Classes and objects** — defining reusable behavior
- **Instance variables** — storing object state
- **Methods** — encapsulating behavior
- **Type checking** — validating input
- **Arrays and loops** — collecting and generating data
- **Random number generation** — simulating unpredictability

The goal: build a `DiceSet` class that can roll N dice and return values between 1 and 6.

## The DiceSet Class Structure

```ruby
class DiceSet
  attr_reader :values

  def initialize
    @values = []
  end

  def roll(number_of_rolls)
    # Validate input
    # Generate random integers 1-6
    # Store results in @values
  end
end
```

## Core Concepts Demonstrated

### 1. Instance State with `attr_reader`

```ruby
attr_reader :values
```

Creates a **read-only getter** for `@values`. Outside the class, you can read the rolled values but cannot assign to `@values` directly (that's an implementation detail):

```ruby
dice = DiceSet.new
dice.roll(5)
dice.values       # => [4, 2, 6, 1, 3]
dice.values = []  # => NoMethodError — no setter
```

### 2. Constructor (`initialize`)

```ruby
def initialize
  @values = []
end
```

The constructor runs once when you call `DiceSet.new`. It sets up the initial empty array for storing dice results.

### 3. Input Validation with `is_a?`

Check that the argument is the correct type before using it:

```ruby
def roll(number_of_rolls)
  if not number_of_rolls.is_a?(Integer)
    raise "number_of_rolls must be an integer"
  end
end

DiceSet.new.roll(5)      # => works
DiceSet.new.roll("five") # => raises error: "number_of_rolls must be an integer"
```

**Why?** Ruby is dynamically typed, so the caller might pass a string instead of an integer. Validating input prevents cryptic errors later.

### 4. Resetting State on Each Roll

```ruby
@values = []
```

At the start of `roll`, clear the array. Without this, repeated calls would append to the old values:

```ruby
dice = DiceSet.new
dice.roll(3)
dice.values       # => [2, 4, 1]
dice.roll(2)
dice.values       # => [5, 6] — not [2, 4, 1, 5, 6]
```

### 5. Generating Random Dice Values (1-6)

The tricky part: Ruby's `rand` returns a float `0.0...1.0`. To get 1-6:

#### Approach 1: `rand(1..6)` (simplest)
```ruby
@values << rand(1..6)
```

Directly generate a random integer in the range 1-6. This is the idiomatic way.

#### Approach 2: `1 + rand(6)` (also clean)
```ruby
@values << (1 + rand(6))
```

`rand(6)` gives 0-5, then add 1 to shift to 1-6.

#### Approach 3: `(rand*6).to_i + 1` (less common)
```ruby
@values << ((rand * 6).to_i + 1)
```

Multiply `rand` (0.0-1.0) by 6 to get 0.0-6.0, convert to integer (0-5), then add 1.

**Avoid:**
```ruby
((rand*10).to_i + 1) % 6  # Wrong! Can produce 0
(rand*10).to_i            # Wrong! Produces 0-9, not 1-6
```

### 6. Looping and Accumulating with `times`

```ruby
number_of_rolls.times do
  @values << (1 + rand(6))
end
```

Or equivalently with curly braces:

```ruby
number_of_rolls.times { @values << (1 + rand(6)) }
```

The `times` method calls the block `number_of_rolls` times, accumulating results in `@values`.

## Testing Behaviors

### Test 1: Object Creation

```ruby
dice = DiceSet.new
assert_not_nil dice
```

Verify that `.new` returns a valid object.

### Test 2: Rolling Produces Correct Values

```ruby
dice.roll(5)
assert dice.values.is_a?(Array), "should be an array"
assert_equal 5, dice.values.size

dice.values.each do |value|
  assert value >= 1 && value <= 6, "value #{value} must be between 1 and 6"
end
```

Verify:
- `values` is an array
- The array has the correct size
- Each value is between 1 and 6 (inclusive)

### Test 3: Values Persist Until Re-Rolled

```ruby
dice.roll(5)
first_time = dice.values
second_time = dice.values
assert_equal first_time, second_time
```

Calling `.roll()` once should produce a fixed set of values. Reading `.values` multiple times returns the same array (no re-rolling).

### Test 4: Values Change Between Rolls

```ruby
dice.roll(5)
first_time = dice.values

dice.roll(5)
second_time = dice.values

assert_not_equal first_time, second_time
```

Calling `.roll()` again should generate new random values (almost always different from before).

**Note:** Mathematically, it's possible (but unlikely) that two consecutive rolls produce the same values. A more robust test would check that values actually changed, not just that they're different arrays.

### Test 5: Different Roll Sizes Work

```ruby
dice.roll(3)
assert_equal 3, dice.values.size

dice.roll(1)
assert_equal 1, dice.values.size
```

Verify that rolling different numbers of dice produces arrays of the correct size.

## Complete Implementation

```ruby
class DiceSet
  attr_reader :values

  def initialize
    @values = []
  end

  def roll(number_of_rolls)
    if not number_of_rolls.is_a?(Integer)
      raise "number_of_rolls must be an integer"
    end

    @values = []
    number_of_rolls.times do
      @values << (1 + rand(6))
    end
  end
end
```

## Common Mistakes

1. **Using wrong random range:**
   ```ruby
   @values << rand(6)        # Wrong: gives 0-5
   @values << rand(1..7)     # Wrong: gives 1-7
   ```

2. **Not resetting on each roll:**
   ```ruby
   # Bad: accumulates across rolls
   number_of_rolls.times { @values << (1 + rand(6)) }
   ```

3. **Forgetting to validate input:**
   ```ruby
   # Bad: crashes with cryptic error if number_of_rolls is not an integer
   number_of_rolls.times { ... }
   ```

4. **Using `attr_accessor` instead of `attr_reader`:**
   ```ruby
   # Bad: allows external code to directly set values
   attr_accessor :values
   ```
   With `attr_reader`, the array can only be populated by calling `roll()`.

5. **Storing the input instead of rolling:**
   ```ruby
   # Bad: just returns the input
   def roll(n)
     @values = [n]
   end
   ```

## Key Takeaways

- **Encapsulation:** `@values` is private; the outside world uses `roll()` and reads via `values`.
- **Validation:** Check that input is the correct type before using it.
- **State management:** Clear old state before generating new state.
- **Random generation:** Use `rand(1..6)` or `1 + rand(6)` for dice.
- **Testing:** Verify size, range, persistence, and change between rolls.

## Quick Reference

| Concept | Example |
| --- | --- |
| Create a dice set | `dice = DiceSet.new` |
| Roll dice | `dice.roll(5)` |
| Read values | `dice.values` |
| Random integer 1-6 | `rand(1..6)` or `1 + rand(6)` |
| Loop N times | `n.times { ... }` or `n.times do ... end` |
| Check type | `value.is_a?(Integer)` |
| Array size | `array.size` or `array.length` |
| Raise error | `raise "message"` |
