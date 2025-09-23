{ vars, colors, ... }:

let
  linksText =
    if (vars.network.server.enable == true) then
      ''
        <a href="https://${vars.network.server.domain}/searxng/" class="link" data-short="/sx/" data-full="searxng">/sx/</a>
        <a href="https://${vars.network.server.domain}/vaultwarden/" class="link" data-short="/vw/" data-full="vaultwarden">/vw/</a>
        <a href="https://${vars.network.server.domain}/i2pd/" class="link" data-short="/ip/" data-full="i2pd">/ip/</a>
        <a href="https://${vars.network.server.domain}/qbt/" class="link" data-short="/qb/" data-full="qbittorrent">/qb/</a>
        <a href="https://${vars.network.server.domain}/jellyfin/" class="link" data-short="/jf/" data-full="jellyfin">/jf/</a>
      ''
    else
      '''';
in
{
  home-manager.users."${vars.user.name}" = {
    home.file.".local/share/home.html".text = ''
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>home</title>
          <style>
              body {
                  background-color: #${colors.bg0};
                  display: flex;
                  flex-direction: column;
                  align-items: center;
                  justify-content: center;
                  height: 100vh;
                  font-family: 'IBM Plex Sans';
                  margin: 0;
              }

              #linksContainer, #selfHostContainer {
                  display: grid;
                  grid-template-columns: repeat(5, 1fr);
                  gap: 10px;
                  font-size: 18px;
                  padding-bottom: 20px;
                  margin-top: 20px;
              }

              #selfHostContainer {
                  border-bottom: 3px solid #${colors.blue2};
              }

              .link {
                  text-align: center;
                  padding: 20px 17px;
                  color: #${colors.fg0};
                  text-decoration: none;
                  border-radius: 5px;
                  background-color: #${colors.bg3};
                  transition: background-color 0.3s ease;
                  min-width: 110px;
              }

              .link:hover {
                  background-color: var(--random-color);
                  color: #${colors.bg0};
              }

              .link span {
                  text-decoration: none;
              }
          </style>
      </head>
      <body>
          <div id="selfHostContainer">
              ${linksText}
          </div>
          <div id="linksContainer">
            <a href="https://open.spotify.com" class="link" data-short="/op/" data-full="spotify">/op/</a>
            <a href="https://youtube.com" class="link" data-short="/yt/" data-full="youtube">/yt/</a>
            <a href="https://instagram.com" class="link" data-short="/ig/" data-full="instagram">/ig/</a>
            <a href="https://discord.com/channels/@me" class="link" data-short="/dc/" data-full="discord">/dc/</a>
            <a href="https://lichess.org" class="link" data-short="/li/" data-full="lichess">/li/</a>

            <a href="https://last.fm" class="link" data-short="/fm/" data-full="lastfm">/fm/</a>
            <a href="https://github.com" class="link" data-short="/gh/" data-full="github">/gh/</a>
            <a href="https://monkeytype.com" class="link" data-short="/mt/" data-full="monkeytype">/mt/</a>
            <a href="https://en.wikipedia.org/wiki/Main_Page" class="link" data-short="/wk/" data-full="wikipedia">/wk/</a>
            <a href="https://chatgpt.com" class="link" data-short="/ch/" data-full="chatgpt">/ch/</a>

            <a href="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages" class="link" data-short="/np/" data-full="nix packages">/np/</a>
            <a href="https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages" class="link" data-short="/no/" data-full="nix options">/no/</a>
            <a href="https://home-manager-options.extranix.com/release=master?query=&release=master" class="link" data-short="/hm/" data-full="hm options">/hm/</a>
            <a href="https://wiki.nixos.org/wiki/NixOS_Wiki" class="link" data-short="/nw/" data-full="nixos wiki">/nw/</a>
            <a href="https://wiki.archlinux.org/title/Main_page" class="link" data-short="/aw/" data-full="arch wiki">/aw/</a>
          </div>

          <script>
              function getRandomColor() {
                  const colors = ["#${colors.red}", "#${colors.orange}", "#${colors.yellow}", "#${colors.green}", "#${colors.purple}"];
                  return colors[Math.floor(Math.random() * colors.length)];
              }

              // Add event listeners to each link
              document.querySelectorAll('.link').forEach(link => {
                  link.addEventListener('mouseover', () => {
                      link.style.backgroundColor = getRandomColor();
                      link.textContent = link.dataset.full;
                  });

                  link.addEventListener('mouseout', () => {
                      link.style.backgroundColor = "";
                      link.textContent = link.dataset.short;
                  });
              });

              // Keyboard shortcut map
              const shortcuts = {
                  op: "https://open.spotify.com",
                  yt: "https://youtube.com",
                  ig: "https://instagram.com",
                  dc: "https://discord.com/channels/@me",
                  li: "https://lichess.org",
                  fm: "https://last.fm",
                  gh: "https://github.com",
                  mt: "https://monkeytype.com",
                  wk: "https://en.wikipedia.org/wiki/Main_Page",
                  ch: "https://chatgpt.com",
                  np: "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages",
                  no: "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages",
                  hm: "https://home-manager-options.extranix.com/release=master?query=&release=master",
                  nw: "https://wiki.nixos.org/wiki/NixOS_Wiki",
                  aw: "https://wiki.archlinux.org/title/Main_page",
                  sx: "https://${vars.network.server.domain}/searxng/",
                  vw: "https://${vars.network.server.domain}/vaultwarden/",
                  ip: "https://${vars.network.server.domain}/i2pd/",
                  qb: "https://${vars.network.server.domain}/qbt/",
                  jf: "https://${vars.network.server.domain}/jellyfin/"
              };

              // Track key sequence
              let buffer = "";
              document.addEventListener("keydown", (e) => {
                  if (e.key.length === 1 && /^[a-z]$/i.test(e.key)) {
                      buffer += e.key.toLowerCase();
                      if (buffer.length > 2) buffer = buffer.slice(-2);
                      if (shortcuts[buffer]) {
                          window.location.href = shortcuts[buffer];;
                          buffer = "";
                      }
                  } else {
                      buffer = "";
                  }
              });
          </script>
      </body>
      </html>
    '';
  };
}
