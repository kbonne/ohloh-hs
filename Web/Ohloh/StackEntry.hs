-- Copyright © 2012 Frank S. Thomas <frank@timepit.eu>
-- All rights reserved.
--
-- Use of this source code is governed by a BSD-style license that
-- can be found in the LICENSE file.

-- | Ohloh API Reference: <http://meta.ohloh.net/referencestack_entry/>
module Web.Ohloh.StackEntry (
  StackEntry(..),
  xpStackEntry
) where

import Data.Lens.Common
import Text.XML.HXT.Arrow.Pickle

import Web.Ohloh.Common
import Web.Ohloh.Lens.IdL
import Web.Ohloh.Project

-- | 'StackEntry' joins one 'Web.Ohloh.Stack.Stack' to one
--   'Web.Ohloh.Project.Project'.
data StackEntry = StackEntry {
  seId :: String,
  seStackId :: String,
  seProjectId :: String,
  seCreatedAt :: String,
  seProject :: Maybe Project
} deriving (Eq, Read, Show)

instance XmlPickler StackEntry where
  xpickle = xpStackEntry

instance ReadXmlString StackEntry
instance ShowXmlString StackEntry

xpStackEntry :: PU StackEntry
xpStackEntry =
  xpElem "stack_entry" $
    xpWrap (uncurry5 StackEntry,
            \(StackEntry i  si  pi  ca  p) ->
                        (i, si, pi, ca, p)) $
    xp5Tuple (xpElem "id" xpText0)
             (xpElem "stack_id" xpText0)
             (xpElem "project_id" xpText0)
             (xpElem "created_at" xpText0)
             (xpOption xpProject)

instance IdL StackEntry where
  idL = lens seId $ \id se -> se { seId = id }
