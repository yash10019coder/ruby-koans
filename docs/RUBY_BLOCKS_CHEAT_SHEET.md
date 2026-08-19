# Ruby Blocks Cheat Sheet

This matches the ideas in `about_blocks.rb`.

## The Three Things to Keep Separate

Ruby has three related but different concepts:

- **Block**: code attached to a method call. It is not a normal value by itself.
- **Proc/lambda**: an object that stores callable code and can be assigned to a variable.
- **Method**: a named operation called with parentheses or without them.

```ruby
# Block attached to a method call
method_with_block { 1 + 2 }

# Lambda stored in a variable
add_one = lambda { |number| number + 1 }

# Named method
def add_one(number)
  number + 1
end
```

## The Practical Convention

You do not need all of the block syntax at once. Choose based on where the behavior belongs:

- Use a **method** when the behavior has a name and belongs to the class or object.
- Use a **block** for temporary behavior used by one method call.
- Use a **lambda** when the behavior must be stored, reused, or passed around as a value.

In everyday Ruby, this is the most common pattern:

```ruby
numbers = [1, 2, 3]
numbers.map { |number| number + 1 }
# => [2, 3, 4]
```

If the same operation is reused, store it in a lambda and pass it with `&`:

```ruby
add_one = ->(number) { number + 1 }
numbers.map(&add_one)
# => [2, 3, 4]
```

These two forms do the same thing:

```ruby
numbers.map { |number| number + 1 }
numbers.map(&add_one)
```

`yield`, `&block`, and `block.call` are mainly tools for **writing methods that accept blocks**. When using Ruby's built-in methods such as `map`, `each`, and `select`, you normally just provide a block.

## Passing a Block to a Method

A method can receive a block and run it with `yield`:

```ruby
def method_with_block
  yield
end

method_with_block { 1 + 2 } # => 3
```

The block can receive values from `yield`:

```ruby
def greet
  yield("Jim")
end

greet { |name| name.upcase } # => "JIM"
```

A method can yield more than once:

```ruby
def many_yields
  yield(:peanut)
  yield(:butter)
end

result = []
many_yields { |item| result << item }
# result => [:peanut, :butter]
```

Use `block_given?` when the block is optional:

```ruby
def maybe_run
  block_given? ? yield : :no_block
end
```

## `yield` Versus `&block`

These two methods can do the same job:

```ruby
def double_with_yield
  yield(10)
end

def double_with_proc(&block)
  block.call(10)
end
```

Use `yield` when you only need to run the block. Use `&block` when you need the block as an object, for example to call it later, pass it elsewhere, or inspect it.

## What `&` Means

`&` converts between a block and a `Proc`/lambda object at a method boundary.

### Lambda object to method block

```ruby
make_upper = lambda { |text| text.upcase }

method_with_block_arguments(&make_upper)
```

This is equivalent to:

```ruby
method_with_block_arguments { |text| text.upcase }
```

The method expects a block because it uses `yield("Jim")`. Without `&`, the lambda would be treated as an ordinary argument, not as the block that `yield` runs.

### Method block to Proc object

```ruby
def method_with_explicit_block(&block)
  block.call(10)
end

method_with_explicit_block { |number| number * 2 } # => 20
```

Here, `&block` captures the attached block as a `Proc` object so `.call` can invoke it.

## Calling a Lambda

A lambda is an object, so Ruby does not use ordinary method-call syntax for a variable:

```ruby
add_one = lambda { |number| number + 1 }

add_one.call(10) # => 11
add_one[10]      # => 11
add_one.(10)     # => 11
```

`add_one(10)` looks for a method named `add_one`; it does not invoke the lambda stored in the local variable. Prefer `.call` when learning or when clarity matters. `[]` and `.()` are valid shorthand.

## Curly Braces and `do...end`

Both create blocks:

```ruby
method_with_block { 1 + 2 }

method_with_block do
  1 + 2
end
```

Use braces for short expressions and `do...end` for multi-line blocks. They also have different precedence when a method call has arguments, so braces are often clearer for tightly attached transformations.

## Scope

Blocks can read and change local variables created outside them:

```ruby
value = :initial
method_with_block { value = :changed }
# value => :changed
```

A block can create its own block-local variable with a semicolon:

```ruby
number = 10
method_with_block { |;number| number = 20 }
# outer number is still 10
```

## Quick Translation Table

| Ruby syntax | Meaning |
| --- | --- |
| `yield(value)` | Run the attached block |
| `block_given?` | Check whether a block was attached |
| `&block` in a definition | Capture the block as a `Proc` |
| `&callable` in a call | Pass a `Proc`/lambda as the method's block |
| `block.call(value)` | Run a captured `Proc`/lambda |
| `lambda { ... }` | Create a lambda object |
| `callable[value]` | Alternative lambda/Proc invocation |

## The Mental Model

```text
method_with_block { code }
       |
       +-- method receives an attached block
       +-- yield runs that block

lambda { code }
       |
       +-- creates a callable object
       +-- .call runs that object
       +-- & converts it into an attached block
```
