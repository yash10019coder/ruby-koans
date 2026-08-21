# Ruby Truth and Falsehood Notes

This matches the ideas in `about_true_and_false.rb`.

Only `false` and `nil` are falsey in Ruby. Everything else is truthy, including
`0`, `""`, and `[]`.

`==` compares values. `nil?` asks whether an object is exactly `nil`; it does
not ask whether the object is generally falsey.
