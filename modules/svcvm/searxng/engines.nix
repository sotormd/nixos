{ lib, ... }:

{
  # upstream searxng adds/removes engines often
  # see https://docs.searxng.org/user/configured_engines.html
  services.searx.settings.engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {

    # general > blogs
    "searchmysite".disabled = true;
    "wiby".disabled = true;

    # general > books
    "openlibrary".disabled = true;

    # general > currency
    "currency".disabled = true;

    # general > translate
    "dictzone".disabled = true;
    "lingva".disabled = true;
    "mozhi".disabled = true;
    "mymemory translated".disabled = true;

    # general > web
    "bing".disabled = true;
    "brave".disabled = true;
    "duckduckgo".disabled = false;
    "google cse".disabled = false;
    "mojeek".disabled = true;
    "presearch".disabled = true;
    "presearch videos".disabled = true;
    "qwant".disabled = true;
    "startpage".disabled = false;
    "yahoo".disabled = true;
    "seznam".disabled = true;
    "naver".disabled = true;

    # general > wikimedia
    "wikibooks".disabled = true;
    "wikiquote".disabled = true;
    "wikisource".disabled = true;
    "wikispecies".disabled = true;
    "wikiversity".disabled = true;
    "wikivoyage".disabled = true;

    # general > without further subgrouping
    "ayo".disabled = true;
    "boardreader".disabled = true;
    "crowdview".disabled = true;
    "ddg definitions".disabled = true;
    "dogpile".disabled = true;
    "encyclosearch".disabled = true;
    "fastbot".disabled = true;
    "fireball".disabled = true;
    "fynd".disabled = true;
    "gabanza".disabled = true;
    "gmx".disabled = true;
    "infospace".disabled = true;
    "mwmbl".disabled = true;
    "privacywall".disabled = true;
    "resulthunter".disabled = true;
    "searchtoday".disabled = true;
    "tineye".disabled = true;
    "tusksearch".disabled = true;
    "vuhuv".disabled = true;
    "wikidata".disabled = true;
    "wikipedia".disabled = false;
    "wolframalpha".disabled = true;
    "yacy".disabled = true;
    "yandex".disabled = true;
    "yep".disabled = true;
    "zapmeta".disabled = true;
    "searchch".disabled = true;
    "bdp".disabled = true;
    "reloado".disabled = true;
    "tagesschau".disabled = true;
    "wikimini".disabled = true;
    "abcnyheter".disabled = true;
    "360search".disabled = true;
    "baidu".disabled = true;
    "quark".disabled = true;
    "sogou".disabled = true;

    # images > icons
    "devicons".disabled = true;
    "flaticon".disabled = true;
    "lucide".disabled = true;
    "material icons".disabled = true;
    "selfhst icons".disabled = true;
    "uxwing".disabled = true;

    # images > web
    "bing images".disabled = true;
    "brave.images".disabled = true;
    "google cse images".disabled = false;
    "mojeek images".disabled = true;
    "presearch images".disabled = true;
    "qwant images".disabled = true;
    "startpage images".disabled = false;

    # images > without further subgrouping
    "1x".disabled = true;
    "500px".disabled = true;
    "adobe stock".disabled = true;
    "artic".disabled = true;
    "artstation".disabled = true;
    "cara".disabled = true;
    "deviantart".disabled = true;
    "dogpile images".disabled = true;
    "duckduckgo images".disabled = false;
    "findfiles images".disabled = true;
    "findthatmeme".disabled = true;
    "flickr".disabled = true;
    "frinkiac".disabled = true;
    "giphy".disabled = true;
    "imgur".disabled = true;
    "ipernity".disabled = true;
    "library of congress".disabled = true;
    "magnific".disabled = true;
    "openverse".disabled = true;
    "pexels".disabled = true;
    "picjumbo".disabled = true;
    "pinterest".disabled = true;
    "pixabay images".disabled = true;
    "privacywall images".disabled = true;
    "public domain image archive".disabled = true;
    "resulthunter images".disabled = true;
    "shopify stock".disabled = true;
    "sogou images".disabled = true;
    "stockshop".disabled = true;
    "tusksearch images".disabled = true;
    "unsplash".disabled = true;
    "vuhuv images".disabled = true;
    "wikicommons.images".disabled = true;
    "yacy images".disabled = true;
    "yandex images".disabled = true;
    "naver images".disabled = true;
    "baidu images".disabled = true;
    "quark images".disabled = true;

    # videos > web
    "bing videos".disabled = true;
    "brave.videos".disabled = true;
    "qwant videos".disabled = true;

    # videos > without further subgrouping
    "360search videos".disabled = true;
    "adobe stock video".disabled = true;
    "bilibili".disabled = true;
    "bitchute".disabled = true;
    "dailymotion".disabled = true;
    "dogpile videos".disabled = true;
    "duckduckgo videos".disabled = true;
    "findfiles videos".disabled = true;
    "fireball videos".disabled = true;
    "google play movies".disabled = true;
    "media.ccc.de".disabled = true;
    "odysee".disabled = true;
    "peertube".disabled = true;
    "pixabay videos".disabled = true;
    "privacywall videos".disabled = true;
    "rumble".disabled = true;
    "sepiasearch".disabled = true;
    "tusksearch videos".disabled = true;
    "vimeo".disabled = true;
    "vuhuv videos".disabled = true;
    "wikicommons.videos".disabled = true;
    "youtube".disabled = true;
    "mediathekviewweb".disabled = true;
    "ina".disabled = true;
    "niconico".disabled = true;
    "naver videos".disabled = true;
    "acfun".disabled = true;
    "iqiyi".disabled = true;
    "sogou videos".disabled = true;

    # news > web
    "mojeek news".disabled = true;
    "presearch news".disabled = true;
    "startpage news".disabled = true;

    # news > wikimedia
    "wikinews".disabled = true;

    # news > misc
    "bing news".disabled = true;
    "brave.news".disabled = true;
    "dogpile news".disabled = true;
    "duckduckgo news".disabled = true;
    "fireball news".disabled = true;
    "google news".disabled = true;
    "qwant news".disabled = true;
    "reuters".disabled = true;
    "tusksearch news".disabled = true;
    # repeat "tagesschau".disabled = true;
    "ansa".disabled = true;
    "il post".disabled = true;
    "naver news".disabled = true;
    "sogou wechat".disabled = true;

    # map
    "apple maps".disabled = true;
    "openstreetmap".disabled = true;
    "photon".disabled = true;

    # music > lyrics
    "genius".disabled = true;

    # music > radio
    "radio browser".disabled = true;

    # music > misc
    "adobe stock audio".disabled = true;
    "bandcamp".disabled = true;
    "deezer".disabled = true;
    "findfiles music".disabled = true;
    "mixcloud".disabled = true;
    "soundcloud".disabled = true;
    "wikicommons.audio".disabled = true;
    "yandex music".disabled = true;
    # repeat "youtube".disabled = true;

    # it > packages
    "alpine linux packages".disabled = true;
    "cachy os packages".disabled = true;
    "crates.io".disabled = true;
    "docker hub".disabled = true;
    "hex".disabled = true;
    "hoogle".disabled = true;
    "lib.rs".disabled = true;
    "metacpan".disabled = true;
    "npm".disabled = true;
    "packagist".disabled = true;
    "pkg.go.dev".disabled = true;
    "pub.dev".disabled = true;
    "pypi".disabled = true;
    "rubygems".disabled = true;
    "voidlinux".disabled = true;

    # it > q&a
    "askubuntu".disabled = true;
    "caddy.community".disabled = true;
    "discuss.python".disabled = true;
    "pi-hole.community".disabled = true;
    "stackoverflow".disabled = true;
    "superuser".disabled = true;

    # it > repos
    "bitbucket".disabled = true;
    "codeberg".disabled = true;
    "gitea.com".disabled = true;
    "github".disabled = true;
    "gitlab".disabled = true;
    "huggingface".disabled = true;
    "huggingface datasets".disabled = true;
    "huggingface spaces".disabled = true;
    "ollama".disabled = true;
    "sourcehut".disabled = true;

    # it > software wikis
    "arch linux wiki".disabled = true;
    "free software directory".disabled = true;
    "gentoo".disabled = true;
    "nixos wiki".disabled = true;

    # it > misc
    "anaconda".disabled = true;
    "habrahabr".disabled = true;
    "hackernews".disabled = true;
    "lobste.rs".disabled = true;
    "mankier".disabled = true;
    "mdn".disabled = true;
    "microsoft learn".disabled = true;
    "national vulnerability database".disabled = true;
    "baidu kaifa".disabled = true;

    # science > scientific publications
    "arxiv".disabled = true;
    "crossref".disabled = true;
    "google scholar".disabled = true;
    "openalex".disabled = true;
    "pubmed".disabled = true;
    "semantic scholar".disabled = true;

    # science > wikimedia
    # repeat "wikispecies".disabled = true;

    # science > without further subgrouping
    "openairedatasets".disabled = true;
    "openairepublications".disabled = true;
    "pdbe".disabled = true;

    # files > apps
    "apk mirror".disabled = true;
    "apple app store".disabled = true;
    "fdroid".disabled = true;
    "google play apps".disabled = true;

    # files > books
    "annas archive".disabled = true;

    # files > without further subgrouping
    "1337x".disabled = true;
    "bt4g".disabled = true;
    "btdigg".disabled = true;
    "findfiles".disabled = true;
    "kickass".disabled = true;
    "library genesis".disabled = true;
    "nyaa".disabled = true;
    "openrepos".disabled = true;
    "piratebay".disabled = true;
    "solidtorrents".disabled = true;
    "tokyotoshokan".disabled = true;
    "wikicommons.files".disabled = true;

    # social media
    "9gag".disabled = true;
    # repeat "boardreader".disabled = true;
    "lemmy comments".disabled = true;
    "lemmy communities".disabled = true;
    "lemmy posts".disabled = true;
    "lemmy users".disabled = true;
    "mastodon hashtags".disabled = true;
    "mastodon users".disabled = true;
    "reddit".disabled = true;
    "tootfinder".disabled = true;

    # other > misc
    "emojipedia".disabled = true;
    "erowid".disabled = true;
    "fyyd".disabled = true;
    "goodreads".disabled = true;
    "podcastindex".disabled = true;
    "steam".disabled = true;
    "chefkoch".disabled = true;
    "destatis".disabled = true;

  };
}
