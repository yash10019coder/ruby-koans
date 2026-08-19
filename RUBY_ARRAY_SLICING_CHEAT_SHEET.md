# Ruby Array Slicing Cheat Sheet

Use this when Ruby slicing feels inconsistent.

## Core Forms

1. `array[start, length]`
2. `array[range]`

Both slice arrays, but they use different rules.

## Quick Rules

- `start == array.length` with `length == 0` returns `[]`
- `start > array.length` returns `nil`
- Negative index means offset from end: `-1` is last element
- In range slicing, negative indexes are resolved against the array length first

## Examples

Assume:

```ruby
array = [:peanut, :butter, :and, :jelly]
# indexes:   0         1       2      3
```

### start, length

```ruby
array[0,1]   # => [:peanut]
array[2,2]   # => [:and, :jelly]
array[2,20]  # => [:and, :jelly]
array[4,0]   # => []
array[4,100] # => []
array[5,0]   # => nil
```

### range

```ruby
array[0..2]   # => [:peanut, :butter, :and]
array[0...2]  # => [:peanut, :butter]
array[2..-1]  # => [:and, :jelly]
```

## Why `array[2..-1]` Works

`-1` is converted to the last valid index for this array.
For length 4, `-1` becomes `3`, so `array[2..-1]` behaves like `array[2..3]`.

## Common Confusion

```ruby
(2..-1).to_a   # => []
array[2..-1]   # => [:and, :jelly]
```

These are different operations:

- `(2..-1).to_a` is numeric range iteration
- `array[2..-1]` is array index slicing

## Safe Normalization Pattern

If you always want an array result:

```ruby
slice = array[i, n] || []
```
