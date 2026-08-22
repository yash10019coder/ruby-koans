# Ruby Hashes Notes

This matches the ideas in `about_hashes.rb`.

## What Is a Hash?

A hash is a **key-value data structure**. Unlike arrays (which use numeric indices), hashes use any object as a key and can store any value.

```ruby
# Array: uses numeric indices
array = ["uno", "dos", "tres"]
array[0]   # => "uno"

# Hash: uses keys (usually symbols or strings)
hash = { :one => "uno", :two => "dos", :three => "tres" }
hash[:one]   # => "uno"
hash[:two]   # => "dos"
```

## Creating Hashes

### Hash Literal (most common)

```ruby
hash = { :one => "uno", :two => "dos" }
```

Modern Ruby also accepts this cleaner syntax:

```ruby
hash = { one: "uno", two: "dos" }  # symbol: value (same as :one => "uno")
```

### Hash.new

```ruby
empty_hash = Hash.new
empty_hash.size  # => 0
empty_hash == {} # => true
```

## Accessing Hash Values

### Using `[]` — Returns nil if missing

```ruby
hash = { :one => "uno", :two => "dos" }
hash[:one]       # => "uno"
hash[:missing]   # => nil (silent, no error)
```

**Problem:** You don't know if a key is actually missing or if the value is genuinely `nil`.

### Using `.fetch()` — Raises error if missing

```ruby
hash = { :one => "uno" }
hash.fetch(:one)        # => "uno"
hash.fetch(:missing)    # => IndexError: key not found: :missing
```

**Better:** `.fetch()` is defensive. It catches typos in key names and makes errors explicit.

```ruby
# Using [] — bug goes unnoticed
user = { name: "Alice" }
age = user[:age]  # => nil (oops, typo in key, but no error!)
puts age.upcase   # => NoMethodError (error appears much later)

# Using .fetch() — bug caught immediately
age = user.fetch(:age)  # => IndexError (you see the problem right away)
```

## Accessing with `.fetch()` and Defaults

If a key is missing, provide a default instead of raising:

```ruby
hash = { :one => "uno" }
hash.fetch(:missing, "default value")  # => "default value"
hash.fetch(:one, "default")            # => "uno"
```

## Modifying Hashes

Hashes are **mutable** — you can change them after creation:

```ruby
hash = { :one => "uno", :two => "dos" }
hash[:one] = "eins"      # change existing value
hash[:three] = "tres"    # add new key-value pair

# hash is now { :one => "eins", :two => "dos", :three => "tres" }
```

## Hash Keys and Values

Extract all keys or all values as arrays:

```ruby
hash = { :one => "uno", :two => "dos", :three => "tres" }

hash.keys    # => [:one, :two, :three] (array of keys)
hash.values  # => ["uno", "dos", "tres"] (array of values)

hash.keys.size    # => 3
hash.keys.include?(:one)  # => true
hash.values.include?("dos")  # => true
```

Use `.keys` and `.values` to iterate or check membership:

```ruby
if hash.keys.include?(:four)
  puts hash[:four]
else
  puts "Key not found"
end
```

## Hash Ordering

**In modern Ruby (1.9+):** Hashes preserve insertion order. But logically, hashes are **unordered**:

```ruby
hash1 = { :one => "uno", :two => "dos" }
hash2 = { :two => "dos", :one => "uno" }

hash1 == hash2  # => true (same keys and values, order doesn't matter for equality)
```

Two hashes are equal if they have the same key-value pairs, regardless of order.

## Combining Hashes with `.merge()`

```ruby
hash = { "jim" => 53, "amy" => 20, "dan" => 23 }
new_hash = hash.merge({ "jim" => 54, "jenny" => 26 })

# new_hash => { "jim" => 54, "amy" => 20, "dan" => 23, "jenny" => 26 }
# hash => { "jim" => 53, "amy" => 20, "dan" => 23 } (unchanged)
```

`.merge()` **creates a new hash** and doesn't modify the original. Values from the argument override values in the original hash.

For in-place merging, use `.merge!()`:

```ruby
hash.merge!(new_hash)  # modifies hash directly
```

## Default Values

When you access a missing key, Ruby can return something other than `nil`.

### 1. Simple Default Value

```ruby
hash = Hash.new("default")
hash[:one] = 1

hash[:one]   # => 1
hash[:two]   # => "default"
```

Every missing key returns the same default value.

### 2. Default Block (Recommended for mutable defaults)

```ruby
hash = Hash.new { |h, k| h[k] = [] }

hash[:one] << "uno"
hash[:two] << "dos"

hash[:one]   # => ["uno"]
hash[:two]   # => ["dos"]
hash[:three] # => []
```

The block runs each time a missing key is accessed, creating a **new object** each time. This avoids the shared-object problem.

The block parameters:
- `h` — the hash itself
- `k` — the key that was accessed
- `h[k] = []` — assign a new empty array to that key

### 3. `.default` Attribute

```ruby
hash = Hash.new
hash[:missing]  # => nil

hash.default = "peanut"
hash[:missing]  # => "peanut"
```

You can set or change the default after creating the hash.

## The Mutable Default Trap

**DON'T DO THIS:**

```ruby
hash = Hash.new([])  # bad!

hash[:one] << "uno"
hash[:two] << "dos"

hash[:one]   # => ["uno", "dos"] (BOTH values in same array!)
hash[:two]   # => ["uno", "dos"] (same array!)
hash[:three] # => ["uno", "dos"] (still the same array!)
```

**Why?** The default `[]` is a **single array object** shared by all missing keys. When you mutate it, all keys see the change.

**FIX: Use a block instead:**

```ruby
hash = Hash.new { |h, k| h[k] = [] }  # good!

hash[:one] << "uno"
hash[:two] << "dos"

hash[:one]   # => ["uno"]
hash[:two]   # => ["dos"]
hash[:three] # => []
```

Each missing key gets its own new array.

## Checking Object Identity

The `.object_id` method shows if two objects are the same:

```ruby
hash = Hash.new([])

hash[:one].object_id == hash[:two].object_id  # => true (same array!)

hash2 = Hash.new { |h, k| h[k] = [] }

hash2[:one].object_id == hash2[:two].object_id  # => false (different arrays)
```

## Common Hash Operations

| Operation | Method | Example |
| --- | --- | --- |
| Get value | `hash[key]` or `hash.fetch(key)` | `hash[:name]` |
| Set value | `hash[key] = value` | `hash[:age] = 30` |
| Get keys | `.keys` | `hash.keys` |
| Get values | `.values` | `hash.values` |
| Check key exists | `.key?()` or `.has_key?()` | `hash.key?(:name)` |
| Check value exists | `.value?()` or `.has_value?()` | `hash.value?("Alice")` |
| Delete key | `.delete(key)` | `hash.delete(:age)` |
| Merge hashes | `.merge()` | `hash.merge(other_hash)` |
| Get size | `.size` or `.length` | `hash.size` |
| Clear all | `.clear` | `hash.clear` |

## Iterating Over Hashes

```ruby
hash = { :one => "uno", :two => "dos" }

# Iterate over key-value pairs
hash.each do |key, value|
  puts "#{key}: #{value}"
end

# Iterate over just keys
hash.each_key do |key|
  puts key
end

# Iterate over just values
hash.each_value do |value|
  puts value
end
```

## Literals vs. Variables (From the Koan)

```ruby
# Literal: value written directly
assert_equal { :one => "uno" }, hash

# Variable: name that holds the value
expected = { :one => "uno" }
assert_equal expected, hash
```

Both do the same thing, but using a variable makes error messages clearer when tests fail. It's better practice.

## Best Practices

### 1. Use `.fetch()` for Safety

```ruby
# Good: explicit about what happens if key is missing
user = { name: "Alice" }
age = user.fetch(:age, 18)  # default to 18 if missing

# Bad: silent nil, easy to miss
age = user[:age]  # might be nil, hard to notice
```

### 2. Use Blocks for Mutable Defaults

```ruby
# Good: each key gets its own array
hash = Hash.new { |h, k| h[k] = [] }

# Bad: all keys share the same array
hash = Hash.new([])
```

### 3. Extract Expected Values in Tests

```ruby
# Good: clear what you expect
expected = { :one => "eins", :two => "dos" }
assert_equal expected, hash

# Also okay: inline if simple
assert_equal "eins", hash[:one]
```

### 4. Prefer Symbols for Hash Keys

```ruby
# Good: symbols are immutable identifiers
hash = { :name => "Alice", :age => 30 }

# Works but less idiomatic: strings as keys
hash = { "name" => "Alice", "age" => 30 }
```

## Quick Reference

```ruby
# Create
hash = { :key => "value" }
hash = Hash.new
hash = Hash.new("default")
hash = Hash.new { |h, k| h[k] = [] }

# Access
hash[:key]              # => value or nil
hash.fetch(:key)        # => value or error
hash.fetch(:key, "def") # => value or default

# Modify
hash[:key] = "new"
hash.delete(:key)
hash.clear

# Inspect
hash.keys
hash.values
hash.size
hash.key?(:key)
hash.value?("value")

# Iterate
hash.each { |k, v| ... }
```
