# Ruby Assertions Notes

This matches the ideas in `about_asserts.rb`.

`assert_equal expected, actual` checks that two values are equal. Read it as:
“the actual result should equal the expected result.”

`assert condition` checks that the condition is truthy. `assert_not_equal`
checks that two values differ.

The koan tests behavior; the blank is usually the value Ruby should produce,
not a new implementation.
