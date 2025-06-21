{
  home-manager,
  vars,
  colors,
  ...
}:

let
  linksText =
    if (vars.network.server.enabled == true) then
      ''
        <a href="https://${vars.network.server.domain}/searxng/" class="link">searxng</a>
        <a href="https://${vars.network.server.domain}/vaultwarden/" class="link">vaultwarden</a>
        <a href="https://${vars.network.server.domain}/i2pd/" class="link">i2pd</a>
        <a href="https://${vars.network.server.domain}/qbt/" class="link">qbt</a>
        <a href="https://${vars.network.server.domain}/jellyfin/" class="link">jellyfin</a>
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
              <a href="https://open.spotify.com" class="link">spotify</a>
              <a href="https://youtube.com" class="link">yt</a>
              <a href="https://instagram.com" class="link">ig</a>
              <a href="https://discord.com/channels/@me" class="link">dc</a>
              <a href="https://lichess.org" class="link">chess</a>

              <a href="https://last.fm" class="link">lastfm</a>
              <a href="https://github.com" class="link">github</a>
              <a href="https://monkeytype.com" class="link">monkeytype</a>
              <a href="https://en.wikipedia.org/wiki/Main_Page" class="link">wikipedia</a>
              <a href="https://chatgpt.com" class="link">chatgpt</a>

              <a href="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages" class="link">nix packages</a>
              <a href="https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages" class="link">nix options</a>
              <a href="https://home-manager-options.extranix.com/release=master?query=&release=master" class="link">hm options</a>
              <a href="https://wiki.nixos.org/wiki/NixOS_Wiki" class="link">nixos wiki</a>
              <a href="https://wiki.archlinux.org/title/Main_page" class="link">arch wiki</a>
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
                  });

                  link.addEventListener('mouseout', () => {
                      link.style.backgroundColor = "";
                  });
              });
          </script>
      </body>
      </html>
    '';
  };
}
