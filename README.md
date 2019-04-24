# Purescript-Simple-Json-Utils

[![Build Status](https://travis-ci.com/justinwoo/purescript-simple-json-utils.svg?branch=master)](https://travis-ci.com/justinwoo/purescript-simple-json-utils)

Some utils for Simple-JSON. Nothing but a bunch of functions made for my own usage.

## Printing MultipleErrors

from [tests](./test/Main.purs)

```purs
readPrintError :: forall a. ReadForeign a => String -> Proxy a -> Maybe String
readPrintError json _ = do
  case readJSON json of
    Right (_ :: a) -> Nothing
    Left e -> Just $ printMultipleErrors e
```

```purs
TypeMismatch: expected: String, actual: Boolean
ErrorAtIndex 0:
  TypeMismatch: expected: String, actual: Boolean
ErrorAtProperty "a":
  TypeMismatch: expected: String, actual: Boolean
ErrorAtProperty "a":
  ErrorAtProperty "b":
    ErrorAtProperty "c":
      TypeMismatch: expected: String, actual: Boolean
```

