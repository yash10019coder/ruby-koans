# Ruby Strings Notes

This matches the ideas in `about_strings.rb`.

Double quotes interpret escapes and interpolation. Single quotes treat most
backslashes literally. Choose the quote that does not conflict with the text,
or escape the conflicting character.

`+` creates a new string. `+=` reassigns a variable to a new string. `<<`
mutates the existing string, so aliases to that object observe the change.

`==` compares string contents; `equal?` compares object identity. `split`
creates an array of pieces, and `join` combines array elements into a string.
