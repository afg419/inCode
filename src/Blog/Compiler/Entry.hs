{-# LANGUAGE ImplicitParams    #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TupleSections     #-}

module Blog.Compiler.Entry where

import           Blog.Types
import           Blog.Util
import           Blog.Util.Preprocessor
import           Blog.Util.Tag
import           Blog.View
import           Blog.View.Entry
import           Control.Monad
import           Data.Bifunctor
import           Data.Default
import           Data.Foldable
import           Data.List
import           Data.Maybe
import           Data.Ord
import           Hakyll
import           Hakyll.Web.Blaze
import           System.FilePath
import           Text.Read              (readMaybe)
import qualified Data.Text              as T
import qualified Text.Pandoc            as P
import qualified Text.Pandoc.Walk       as P

compileEntry
    :: (?config :: Config)
    => Compiler (Item Entry)
compileEntry = do
    i         <- getUnderlying
    eRawBody  <- getResourceBody
    eBody     <- fmap T.unpack
             <$> traverse (preprocessEntry . T.pack) eRawBody
    ePandoc   <- readPandocWith entryReaderOpts eBody
    let ePandocLede = flip fmap ePandoc $ \(P.Pandoc m bs) ->
                        P.Pandoc m
                          . take (prefLedeMax (confBlogPrefs ?config))
                          . takeWhile validLede
                          $ bs
    eTitle    <- either (error . show) id . P.runPure
               . (P.writeMarkdown entryWriterOpts <=< P.readMarkdown entryReaderOpts)
               . T.unwords . T.lines . T.pack
             <$> getMetadataField' i "title"
    eCreate   <- (parseETime =<<) <$> getMetadataField i "create-time"
    ePost     <- (parseETime =<<) <$> getMetadataField i "date"
    eModified <- (parseETime =<<) <$> getMetadataField i "modified-time"
    eIdent    <- fmap T.pack <$> getMetadataField i "identifier"
    eSlug     <- fmap T.pack <$> getMetadataField i "slug"
    eOldSlugs <- maybe [] (map (T.pack . trim) . splitAll ",")
               <$> getMetadataField i "old-slugs"
    eId       <- (readMaybe =<<) <$> getMetadataField i "entry-id"
    tags      <- maybe [] splitTags <$> getMetadataField i "tags"
    cats      <- maybe [] splitTags <$> getMetadataField i "categories"
    sers      <- maybe [] splitTags <$> getMetadataField i "series"

    makeItem Entry { entryTitle      = eTitle
                   , entryContents   = itemBody ePandoc
                   , entryLede       = itemBody ePandocLede
                   , entrySourceFile = toFilePath i
                   , entryCreateTime = eCreate
                   , entryPostTime   = ePost
                   , entryModifyTime = eModified
                   , entryIdentifier = eIdent
                   , entrySlug       = eSlug
                   , entryOldSlugs   = eOldSlugs
                   , entryId         = eId
                   , entryCanonical  = mkCanonical eSlug eIdent (toFilePath i)
                   , entryTags       = (map . second) T.pack
                                     $ map (GeneralTag,)  tags
                                    ++ map (CategoryTag,) cats
                                    ++ map (SeriesTag,)   sers
                   }
  where
    validLede b = case b of
                    P.Header {}      -> False
                    P.HorizontalRule -> False
                    _                -> True

entryCompiler
    :: (?config :: Config)
    => [Identifier]
    -> [(TagType, T.Text)]
    -> Compiler (Item String)
entryCompiler histList allTags = do
    i <- setVersion Nothing <$> getUnderlying
    e <- loadSnapshotBody i "entry"
    allEs <- sortEntries <$> mapM (`loadSnapshotBody` "entry") histList
    let (afts,befs) = break ((== entryPostTime e) . entryPostTime) allEs
        aft = listToMaybe (reverse afts)
        bef = listToMaybe (drop 1 befs)
    allTs <- mapM (uncurry fetchTag)
           . filter (`elem` (entryTags e))
           $ allTags
    let ei = EI { eiEntry     = e
                , eiTags      = sortTags allTs
                , eiPrevEntry = bef
                , eiNextEntry = aft
                }
        pd = def { pageDataTitle   = Just $ entryTitle e
                 , pageDataType    = Just "article"
                 , pageDataDesc    = Just . stripPandoc . entryLede $ e
                 , pageDataCss     = [ "/css/page/entry.css"
                                     , "/css/pygments.css"
                                     ]
                 , pageDataJs      = [ "/js/page/entry_toc.js"
                                     , "/js/disqus_count.js"
                                     , "/js/social.js"
                                     , "/js/jquery/jquery.toc.js"
                                     , "/purescript/entry.js"
                                     ]
                 }
    blazeCompiler pd (viewEntry ei)

entryMarkdownCompiler
    :: (?config :: Config)
    => Compiler (Item String)
entryMarkdownCompiler = do
    i <- setVersion Nothing <$> getUnderlying
    Entry{..} <- loadSnapshotBody i "entry"
    let timeString = maybe T.empty ((" on " <>) . T.pack . renderShortFriendlyTime)
                   $ entryPostTime
    makeItem . T.unpack . T.unlines
      $ [ entryTitle
        , T.map (const '=') entryTitle
        , T.empty
        , T.concat [ "> Originally posted by ["
                   , authorName (confAuthorInfo ?config)
                   , "]("
                   , renderUrl ""
                   , ")"
                   , timeString
                   , "."
                   ]
        , T.concat [ "> [Read online!]("
                   , renderUrl (T.pack entryCanonical)
                   , ")"
                   ]
        , T.empty
        , either (error . show) id . P.runPure
        . P.writeMarkdown entryWriterOpts
        $ entryContents
        ]

entryLaTeXCompiler
    :: (?config :: Config)
    => Compiler (Item String)
entryLaTeXCompiler = do
    templ <- loadBody "latex/templates/default.latex"
    let opts = entryWriterOpts { P.writerTemplate   = Just templ }

    i <- setVersion Nothing <$> getUnderlying
    Entry{..} <- loadSnapshotBody i "entry"
    let eDate    = maybe T.empty (("% " <>) . T.pack . renderShortFriendlyTime)
                 $ entryPostTime
        mdHeader = T.unlines [ "% " <> entryTitle
                             , "% " <> authorName (confAuthorInfo ?config)
                             , eDate
                             , T.empty
                             , T.concat [ "*Originally posted on **"
                                        , "["
                                        , confTitle ?config
                                        , "]("
                                        , renderUrl (T.pack entryCanonical)
                                        , ")**.*"
                                        ]
                             , T.empty
                             , either (error . show) id . P.runPure
                             . P.writeMarkdown entryWriterOpts
                             $ entryContents
                             ]
    body <- makeItem $ T.unpack mdHeader
    fmap (toTex opts) <$> readPandocWith entryReaderOpts body
  where
    toTex :: P.WriterOptions -> P.Pandoc -> String
    toTex opts = either (error . show) T.unpack
               . P.runPure
               . P.writeLaTeX opts
               . P.walk upgrade
               . P.bottomUp stripRules
    stripRules P.HorizontalRule = P.Null
    stripRules other = other
    upgrade p = case p of
                  P.Header n t xs      | n > 1
                      -> P.Header (n - 1) t xs
                  P.Div di@(_,is,_) xs | "note" `elem` is
                      -> P.Div di (P.HorizontalRule : xs ++ [P.HorizontalRule])
                  _
                      -> p

-- entryLedeStripped :: Entry -> T.Text
-- entryLedeStripped = stripPandoc
--                   . P.handleError
--                   . P.readMarkdown entryReaderOpts
--                   . T.unpack
--                   . entryLede

mkCanonical
    :: Maybe T.Text
    -> Maybe T.Text
    -> FilePath
    -> FilePath
mkCanonical slug ident source =
    fromMaybe (source `replaceDirectory` "entry/ident")
  . asum
  $ [ (<.> "html") . ("entry" </>)       . T.unpack <$> slug
    , (<.> "html") . ("entry/ident" </>) . T.unpack <$> ident
    ]

compileTE :: Entry -> Compiler TaggedEntry
compileTE e = do
    ts <- mapM (uncurry fetchTag) (entryTags e)
    return $ TE e (sortTags ts)

sortEntries :: [Entry] -> [Entry]
sortEntries = sortBy (flip $ comparing entryPostTime)
            . filter (isJust . entryPostTime)

sortTaggedEntries :: [TaggedEntry] -> [TaggedEntry]
sortTaggedEntries = sortBy (flip $ comparing (entryPostTime . teEntry))
                  . filter (isJust . entryPostTime . teEntry)

getEntries :: Compiler [Entry]
getEntries = map itemBody <$> loadAllSnapshots ("copy/entries/*" .&&. hasNoVersion) "entry"

getRecentEntries :: (?config :: Config) => Compiler [Entry]
getRecentEntries = take (prefSidebarEntries (confBlogPrefs ?config))
                 . sortEntries
               <$> getEntries
