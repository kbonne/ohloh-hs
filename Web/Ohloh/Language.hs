-- Copyright © 2012 Frank S. Thomas <frank@timepit.eu>
-- All rights reserved.
--
-- Use of this source code is governed by a BSD-style license that
-- can be found in the LICENSE file.

-- | Ohloh API Reference: <http://meta.ohloh.net/referencelanguage/>
module Web.Ohloh.Language (
  Language(..),
  xpLanguage
) where

import Data.Lens.Common
import Text.XML.HXT.Arrow.Pickle

import Web.Ohloh.Common
import Web.Ohloh.Lens.IdL
import Web.Ohloh.Lens.NameL

-- | 'Language' contains the name and various statistics related to a
--   programming language.
data Language = Language {
  langId :: String,
  langName :: String,
  langNiceName :: String,
  langCategory :: String,
  langCode :: Int,
  langComments :: Int,
  langBlanks :: Int,
  langCommentRatio :: Double,
  langProjects :: Int,
  langContributors :: Int,
  langCommits :: Int
} deriving (Eq, Read, Show)

instance XmlPickler Language where
  xpickle = xpLanguage

instance ReadXmlString Language
instance ShowXmlString Language

xpLanguage :: PU Language
xpLanguage =
  xpElem "language" $
    xpWrap (uncurry11 Language,
            \(Language i  n  nn  ca  co  cm  b  cr  p  cn  ci) ->
                      (i, n, nn, ca, co, cm, b, cr, p, cn, ci)) $
    xp11Tuple (xpElem "id" xpText0)
              (xpElem "name" xpText0)
              (xpElem "nice_name" xpText0)
              (xpElem "category" xpText0)
              (xpElem "code" xpInt)
              (xpElem "comments" xpInt)
              (xpElem "blanks" xpInt)
              (xpElem "comment_ratio" xpPrim)
              (xpElem "projects" xpInt)
              (xpElem "contributors" xpInt)
              (xpElem "commits" xpInt)

instance IdL Language where
  idL = lens langId $ \id lang -> lang { langId = id }

instance NameL Language where
  nameL = lens langName $ \name lang -> lang { langName = name }
