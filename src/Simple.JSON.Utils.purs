module Simple.JSON.Utils where

import Prelude

import Data.Foldable (intercalate)
import Foreign (ForeignError(..), MultipleErrors)
import Motsunabe (Doc(..), prettyWithoutTrailing)

printMultipleErrors :: MultipleErrors -> String
printMultipleErrors = prettyWithoutTrailing 80 <<< intercalate DLine <<< map foreignErrorToDoc

foreignErrorToDoc :: ForeignError -> Doc
foreignErrorToDoc (ForeignError s) = DText $ "ForeignError: " <> s
foreignErrorToDoc (TypeMismatch expected actual) = DText "TypeMismatch:" <> DAlt line lines
  where
    line = DText " "
      <> DText "expected: " <> DText expected
      <> DText ", "
      <> DText "actual: " <> DText actual
    lines = DNest 1
       $ DLine <> DText "expected:" <> DNest 1 (DLine <> DText expected)
      <> DLine <> DText "actual:" <> DNest 1 (DLine <> DText actual)
foreignErrorToDoc (ErrorAtIndex i e) = DText ("ErrorAtIndex " <> show i <> ":") <> inner
  where
    inner = DNest 1 $ DLine <> foreignErrorToDoc e
foreignErrorToDoc (ErrorAtProperty p e) =  DText ("ErrorAtProperty \"" <> p <> "\":") <> inner
  where
    inner = DNest 1 $ DLine <> foreignErrorToDoc e
