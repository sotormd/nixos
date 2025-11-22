{ lib, ... }:

{
  services.searx.settings.engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
    # general > translate
    "dictzone".disabled = true;
    "libretranslate".disabled = true;
    "lingva".disabled = true;
    "mozhi".disabled = true;
    "mymemory translated".disabled = true;

    # general > web
    "brave".disabled = false;
    "duckduckgo".disabled = false;
    "google".disabled = false;

    "bing".disabled = true;
    "qwant".disabled = true;
    "startpage".disabled = true;
    "wiby".disabled = true;
    "seznam".disabled = true;
    "mojeek".disabled = true;
    "mullvadleta".disabled = true;
    "mullvadleta brave".disabled = true;
    "presearch".disabled = true;
    "presearch videos".disabled = true;
    "goo".disabled = true;
    "naver".disabled = true;
    "yahoo".disabled = true;

    # general > wikimedia
    "wikibooks".disabled = true;
    "wikiquote".disabled = true;
    "wikisource".disabled = true;
    "wikispecies".disabled = true;
    "wikiversity".disabled = true;
    "wikivoyage".disabled = true;

    # general > misc
    "wikidata".disabled = false;
    "wikipedia".disabled = false;

    "alexandria".disabled = true;
    "ask".disabled = true;
    "cloudflareai".disabled = true;
    "crowdview".disabled = true;
    "currency".disabled = true;
    "ddg definitions".disabled = true;
    "encyclosearch".disabled = true;
    "mwmbl".disabled = true;
    "right dao".disabled = true;
    "searchmysite".disabled = true;
    "stract".disabled = true;
    "tineye".disabled = true;
    "wolframalpha".disabled = true;
    "yacy".disabled = true;
    "yep".disabled = true;
    "bpb".disabled = true;
    "tagesschau".disabled = true;
    "wikimini".disabled = true;
    "360search".disabled = true;
    "baidu".disabled = true;
    "quark".disabled = true;
    "sogou".disabled = true;

    # images > web
    "bing images".disabled = false;
    "brave.images".disabled = false;
    "duckduckgo images".disabled = false;
    "google images".disabled = false;

    "mojeek images".disabled = true;
    "presearch images".disabled = true;
    "qwant images".disabled = true;
    "startpage images".disabled = true;

    # images > misc
    "1x".disabled = true;
    "adobe stock".disabled = true;
    "artic".disabled = true;
    "deviantart".disabled = true;
    "flickr".disabled = true;
    "imgur".disabled = true;
    "ipernity".disabled = true;
    "library of congress".disabled = true;
    "material icons".disabled = true;
    "findthatmeme".disabled = true;
    "openverse".disabled = true;
    "pinterest".disabled = true;
    "public domain image archive".disabled = true;
    "sogou images".disabled = true;
    "svgrepo".disabled = true;
    "unsplash".disabled = true;
    "wallhaven".disabled = true;
    "wikicommons.images".disabled = true;
    "yacy images".disabled = true;
    "yep images".disabled = true;
    "seekr images".disabled = true;
    "baidu images".disabled = true;
    "quark images".disabled = true;

    # videos > web
    "bing videos".disabled = false;
    "brave.videos".disabled = false;
    "duckduckgo videos".disabled = false;
    "google videos".disabled = false;

    "qwant videos".disabled = true;

    # videos > misc
    "youtube".disabled = true;
    "360search videos".disabled = true;
    "adobe stock video".disabled = true;
    "bilibili".disabled = true;
    "bitchute".disabled = true;
    "dailymotion".disabled = true;
    "google play movies".disabled = true;
    "livespace".disabled = true;
    "media.ccc.de".disabled = true;
    "odysee".disabled = true;
    "peertube".disabled = true;
    "piped".disabled = true;
    "rumble".disabled = true;
    "sepiasearch".disabled = true;
    "vimeo".disabled = true;
    "wikicommons.videos".disabled = true;
    "mediathekviewweb".disabled = true;
    "seekr videos".disabled = true;
    "ina".disabled = true;
    "niconico".disabled = true;
    "acfun".disabled = true;
    "iqiyi".disabled = true;
    "sogou videos".disabled = true;

    # news > web
    "duckduckgo news".disabled = true;
    "mojeek news".disabled = true;
    "presearch news".disabled = true;
    "startpage news".disabled = true;

    # news > wikimedia
    "wikinews".disabled = true;

    # news > misc
    "bing news".disabled = true;
    "brave.news".disabled = true;
    "google news".disabled = true;
    "qwant news".disabled = true;
    "reuters".disabled = true;
    "yahoo news".disabled = true;
    "yep news".disabled = true;
    "seekr news".disabled = true;
    "ansa".disabled = true;
    "il post".disabled = true;
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
    "mixcloud".disabled = true;
    "invidious".disabled = true;
    "deezer".disabled = true;
    "soundcloud".disabled = true;
    "wikicommons.audio".disabled = true;
    "piped.music".disabled = true;

    # it > packages
    "crates.io".disabled = false;
    "docker hub".disabled = false;
    "pypi".disabled = false;

    "alpine linux packages".disabled = true;
    "hex".disabled = true;
    "hoogle".disabled = true;
    "lib.rs".disabled = true;
    "metacpan".disabled = true;
    "npm".disabled = true;
    "pub.dev".disabled = true;
    "rubygems".disabled = true;
    "voidlinux".disabled = true;
    "pkg.go.dev".disabled = true;
    "packagist".disabled = true;

    # it > q&a
    "askubuntu".disabled = false;
    "stackoverflow".disabled = false;
    "superuser".disabled = false;

    "caddy.community".disabled = true;
    "discuss.python".disabled = true;
    "pi-hole.community".disabled = true;

    # it > repos
    "github".disabled = false;
    "gitlab".disabled = false;

    "codeberg".disabled = true;
    "bitbucket".disabled = true;
    "gitea.com".disabled = true;
    "sourcehut".disabled = true;
    "huggingface".disabled = true;
    "huggingface spaces".disabled = true;
    "huggingface datasets".disabled = true;
    "ollama".disabled = true;

    # it > software wikis
    "arch linux wiki".disabled = false;
    "free software directory".disabled = false;
    "gentoo".disabled = false;
    "nixos wiki".disabled = false;

    # it > misc
    "anaconda".disabled = true;
    "cppreference".disabled = true;
    "habrahabr".disabled = true;
    "hackernews".disabled = true;
    "lobste.rs".disabled = true;
    "mankier".disabled = true;
    "mdn".disabled = true;
    "microsoft learn".disabled = true;
    "searchcode code".disabled = true;
    "baidu kaifa".disabled = true;

    # science > scientific publications
    "google scholar".disabled = true;
    "arxiv".disabled = true;
    "crossref".disabled = true;
    "pubmed".disabled = true;
    "semantic scholar".disabled = true;

    # science > misc
    "openairedatasets".disabled = true;
    "openairepublications".disabled = true;
    "pdbe".disabled = true;

    # files > apps
    "fdroid".disabled = true;
    "google play apps".disabled = true;
    "apk mirror".disabled = true;
    "apple app store".disabled = true;

    # files > misc
    "1337x".disabled = true;
    "annas archive".disabled = true;
    "bt4g".disabled = true;
    "btdigg".disabled = true;
    "kickass".disabled = true;
    "library genesis".disabled = true;
    "openrepos".disabled = true;
    "piratebay".disabled = true;
    "tokyotoshokan".disabled = true;
    "solidtorrents".disabled = true;
    "z-library".disabled = true;
    "wikicommons.files".disabled = true;
    "nyaa".disabled = true;

    # social media
    "reddit".disabled = true;
    "9gag".disabled = true;
    "lemmy comments".disabled = true;
    "lemmy communities".disabled = true;
    "lemmy posts".disabled = true;
    "lemmy users".disabled = true;
    "mastodon hashtags".disabled = true;
    "mastodon users".disabled = true;
    "tootfinder".disabled = true;

    # other > dictionaries
    "etymonline".disabled = true;
    "wiktionary".disabled = true;
    "wordnik".disabled = true;
    "duden".disabled = true;
    "woxikon.de synonyme".disabled = true;
    "jisho".disabled = true;

    # other > movies
    "imdb".disabled = true;
    "rottentomatoes".disabled = true;
    "tmdb".disabled = true;
    "moviepilot".disable = true;

    # other > shopping
    "geizhals".disabled = true;

    # other > weather
    "duckduckgo weather".disabled = true;
    "openmeteo".disabled = true;
    "wttr.in".disabled = true;

    # other > misc
    "emojipedia".disabled = true;
    "erowid".disabled = true;
    "fyyd".disabled = true;
    "goodreads".disabled = true;
    "openlibrary".disabled = true;
    "podcastindex".disabled = true;
    "yummly".disabled = true;
    "chefkoch".disabled = true;
    "destatis".disabled = true;
    "chinaso images".disabled = true;
    "chinaso news".disabled = true;
    "chinaso videos".disabled = true;
  };
}
