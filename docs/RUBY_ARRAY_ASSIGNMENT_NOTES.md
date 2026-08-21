# Ruby Array Assignment Notes

This matches the ideas in `about_array_assignment.rb`.

Parallel assignment matches values from left to right:

```ruby
first, second = [:one, :two]
```

Extra values are collected with a splat, `*rest`. A splat can also gather the
remaining values when it appears in the middle of an assignment.

When there are too few values, unmatched variables receive `nil`. Assignment
does not require the right side to be an array literal; Ruby applies its
multiple-assignment rules to the values being returned.
