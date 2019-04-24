module Test.Main where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import Partial.Unsafe (unsafeCrashWith)
import Simple.JSON (class ReadForeign, readJSON)
import Simple.JSON.Utils (printMultipleErrors)
import Test.Assert (assertEqual)
import Type.Prelude (Proxy(..))

testJSON1 = """
true
""" :: String

expected1 = "TypeMismatch: expected: String, actual: Boolean" :: String

testJSON2 = """
[
  false
]
""" :: String

expected2 = "ErrorAtIndex 0:\n  TypeMismatch: expected: String, actual: Boolean" :: String

testJSON3 = """
{
  "a": false
}
""" :: String

expected3 = "ErrorAtProperty \"a\":\n  TypeMismatch: expected: String, actual: Boolean" :: String

testJSON4 = """
{
  "a": {
    "b": {
      "c": false
    }
  }
}
""" :: String

readPrintError :: forall a. ReadForeign a => String -> Proxy a -> Maybe String
readPrintError json _ = do
  case readJSON json of
    Right (_ :: a) -> Nothing
    Left e -> Just $ printMultipleErrors e

expect :: forall a. ReadForeign a => String -> String -> Proxy a -> Effect Unit
expect expected json proxy = do
  let result = readPrintError json proxy
  assertEqual { expected: Just expected, actual: result }
  logOrError result

logOrError :: Maybe String -> Effect Unit
logOrError (Just s) = log s
logOrError Nothing = unsafeCrashWith "expected JSON parse error"

main :: Effect Unit
main = do
  log ""
  expect expected1 testJSON1 $ Proxy :: _ String
  expect expected2 testJSON2 $ Proxy :: _ (Array String)
  expect expected3 testJSON3 $ Proxy :: _ { a :: String }
  logOrError $ readPrintError testJSON4 $ Proxy :: _ { a :: { b :: { c :: String } } }
  log ""
