# Ruby Symbols Notes

This matches the ideas in `about_symbols.rb`.

A symbol is an immutable identifier, not an immutable string. It does not have
normal string methods such as `reverse` or `each_char`.

Use `to_s` for string operations and `to_sym` to convert text back:

```ruby
("cats" + "dogs").to_sym # :catsdogs
```

Quoted symbols can contain spaces: `:"cats and dogs"`. Replacing spaces with
underscores creates a different symbol; it is not required for validity.

Ruby can garbage-collect dynamically created symbols in modern versions, so do
not rely on the old rule that symbols always remain until process exit.