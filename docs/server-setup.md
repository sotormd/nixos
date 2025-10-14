# `server` Setup

**Intended for Raspberry Pi hosts using the NixOS aarch64 sd card image.**

## 1. Obtaining a NixOS image.

1. Get a NixOS aarch64 image from [here](https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux/).

2. Verify the checksum of the image.

    ```console
    $ echo "cba2... nixos-...iso" | sha256sum --check
    ```

3. Flash this image onto an SD card after decompressing it.

## 2. First boot.

1. Boot into the SD card. You should be logged in automatically as user `nixos`.

2. Optional: disable annoying dmesg messages.

    ```console
    $ sudo dmesg -n 1
    ```

3. Generate config.

    ```console
    $ sudo nixos-generate-config
    ```

4. Edit the configuration for first rebuild.

    `/etc/nixos/configuration.nix`
    ```nix
    {
    # rest of the config
    # ...

        # enable flakes
        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        # allow using nmtui
        networking.networkmanager.enable = true;

        # easier to set these up now
        networking.hostName = "Foo";
        time.timeZone = "Continent/City";

        # set up a user
        users.users.Bar = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            group = "Bar";

            # for installation only
            password = "test";
        };
        users.groups.Bar = {};

    # ...
    # rest of the config
    }
    ```

5. Connect to the internet.

    ```console
    $ nmtui
    ```

6. Ensure internet connection.

    ```console
    $ ping archlinux.org
    ```

7. Rebuild the configuration and reboot.

    ```console
    $ sudo nixos-rebuild switch
    $ sudo reboot
    ```

## 3. Applying configuration.

1. Once booted into the new installation, log in as the new user and set up basic environment variables.

    ```console
    $ export NIXOS_DIR=/nixos
    $ export NIXOS_ROLE=server
    ```

    See [this](#environment-variables) section for all variables.

2. Clone this repository.

    ```console
    $ sudo mkdir -p $NIXOS_DIR
    $ sudo chown Bar: $NIXOS_DIR
    $ nix shell nixpkgs#git --command git clone https://github.com/sotormd/nixos $NIXOS_DIR
    ```

3. Initialize variables.

    First, check `sudo blkid` output to find the root partition partuuid.

    ```console
    $ export VARS_DEVICE_ROOT=2178694e-02
    $ export VARS_USER_EMAIL=Bar@domain.com
    $ export VARS_NETWORK_SSID=BarsNetwork
    $ export VARS_NETWORK_GATEWAY=10.0.0.1
    $ export VARS_NETWORK_IP=10.0.0.20
    $ export VARS_NETWORK_RANGE=10.0.0.0/24
    $ export VARS_NETWORK_SSH_KEY=AAAA...
    $ $NIXOS_DIR/scripts/nixos init vars
    ```

    See [this](#environment-variables) section for all variables.

4. Initialize secrets.

    ```console
    $ export SECRETS_DUCKDNS_TOKEN=aaa...
    $ $NIXOS_DIR/scripts/nixos init sops
    ```

    It is possible to configure through environment variables.

    See [this](#environment-variables) section for all variables.

5. Edit variables/secrets.

    To ensure all variables are set, edit the variables file.

    ```console
    $ $NIXOS_DIR/scripts/nixos edit vars
    ```

    To ensure all secrets are set, edit the secrets file.

    ```console
    $ nix shell nixpkgs#sops nixpkgs#gnupg --command $NIXOS_DIR/scripts/nixos edit sops
    ```

6. Switch to the new configuration for the first time.

    ```console
    $ nix shell nixpkgs#git --command $NIXOS_DIR/scripts/nixos switch
    ```

7. Reboot the system.

    ```console
    $ sudo reboot
    ```

    If everything goes well, you should be able to log in with your new username and password.


8. Check that the `$NIXOS_DIR` and `$NIXOS_ROLE` environment variables are set.

    ```console
    $ nixos
    ```

    You should see a directory tree of `$NIXOS_DIR` (in this case, of `/nixos`).

9. Enable services.

    Enable required services by setting `network.<service>.enable = true;` in `vars.nix`.
    ```console
    $ nixos edit vars
    ```

    Switch to the new configuration.
    ```console
    $ nixos switch
    ```

### Environment variables.

Full list of possible environment variables:

| Name                                      | Required? | Explanation                                         | Default                                                     | Example                              |
|-------------------------------------------|-----------|-----------------------------------------------------|-------------------------------------------------------------|--------------------------------------|
| `NIXOS_DIR`                               | **Yes**   | Directory where the NixOS configuration is stored.  | -                                                           | `"/nixos"`                           |
| `NIXOS_ROLE`                              | **Yes**   | `laptop` or `server` role                           | -                                                           | `"server"`                           |
| `VARS_DEVICE_HOSTNAME`                    | No        | Hostname of the device.                             | `$(uname -n)`                                               | `"Foo"`                              |
| `VARS_DEVICE_MACHINEID`                   | No        | `systemd` machine-id.                               | `$(cat /etc/machine-id)`                                    | `"51934ba93b754bf28caf413f7e6c65bd"` |
| `VARS_DEVICE_ROOT`                        | **Yes**   | Root partition partuuid.                            | -                                                           | -                                    |
| `VARS_USER_NAME`                          | No        | Username.                                           | `$USER`                                                     | `"Bar"`                              |
| `VARS_USER_EMAIL`                         | **Yes**   | Email used for git commits.                         | -                                                           | `"Bar@domain.com"`                   |
| `VARS_I18N_TIMEZONE`                      | No        | Timezone.                                           | `$(timedatectl show --property=Timezone --value)`           | `"Europe/Berlin"`                    |
| `VARS_I18N_KEYBOARD`                      | No        | Keyboard layout.                                    | `"us"`                                                      | `"us"`                               |
| `VARS_I18N_LOCALE`                        | No        | Locale.                                             | `"en_US.UTF-8"`                                             | `"de_DE.UTF-8"`                      |
| `VARS_NETWORK_INTERFACE`                  | No        | Wireless network interface.                         | `"wlp1s0"`                                                  | `"wlan0"`                            |
| `VARS_NETWORK_SSID`                       | **Yes**   | Wireless network ssid.                              | -                                                           | `"net20"`                            |
| `VARS_NETWORK_GATEWAY`                    | No        | Wireless network gateway.                           | `"192.168.0.1"`                                             | `"10.0.0.0"`                         |
| `VARS_NETWORK_RANGE`                      | No        | CIDR allowed to access server.                      | `"192.168.0.0/24"`                                          | `"10.0.0.0/24"`                      |
| `VARS_NETWORK_IP`                         | **Yes**   | Static local IP address.                            | -                                                           | `"10.0.0.3"`                         |
| `VARS_NETWORK_DUCKDNS_DOMAIN`             | No        | DuckDNS domain name.                                | `"$(uname -n)-server.duckdns.org"`                          | `"nixos-server-0b123df.duckdns.org"` |
| `VARS_NETWORK_SSH_PORT`                   | No        | SSH port.                                           | `"22"`                                                      | `"20000"`                            |
| `VARS_NETWORK_SSH_KEY`                    | No        | Allowed public key.                                 | -                                                           | `"AAAA..."`                          |
| `VARS_NETWORK_UNBOUND_ENABLE`             | No        | Enable Unbound.                                     | `"false"`                                                   | `"true"`                             |
| `VARS_NETWORK_NGINX_ENABLE`               | No        | Enable Nginx.                                       | `"false"`                                                   | `"true"`                             |
| `VARS_NETWORK_SEARXNG_ENABLE`             | No        | Enable SearXNG.                                     | `"false"`                                                   | `"true"`                             |
| `VARS_NETWORK_VAULTWARDEN_ENABLE`         | No        | Enable Vaultwarden.                                 | `"false"`                                                   | `"true"`                             |
| `VARS_NETWORK_VAULTWARDEN_DATA`           | No        | Vaultwarden data directory.                         | `"/var/lib/bitwarden_rs"`                                   | `"/mnt/drive/vaultwarden-data"`      |
| `VARS_NETWORK_VAULTWARDEN_PORT`           | No        | Vaultwarden web vault rocket (loopback) port.       | `"8222"`                                                    | `"20001"`                            |
| `VARS_NETWORK_I2PD_ENABLE`                | No        | Enable I2PD.                                        | `"false"`                                                   | `"true"`                             |
| `VARS_NETWORK_I2PD_SAM_PORT`              | No        | I2PD SAM (loopback) port.                           | `"7656"`                                                    | `"20002"`                            |
| `VARS_NETWORK_I2PD_HTTP_PROXY_PORT`       | No        | I2PD HTTP proxy (LAN) port.                         | `"4444"`                                                    | `"20003"`                            |
| `VARS_NETWORK_I2PD_SOCKS_PROXY_PORT`      | No        | I2PD SOCKS proxy (loopback) port.                   | `"4447"`                                                    | `"20004"`                            |
| `VARS_NETWORK_I2PD_WEBCONSOLE_PROXY_PORT` | No        | I2PD webconsole (loopback) port.                    | `"7070"`                                                    | `"20005"`                            |
| `VARS_NETWORK_QBT_ENABLE`                 | No        | Enable qBittorrent.                                 | `"false"`                                                   | `"true"`                             |
| `VARS_NETWORK_QBT_DATA`                   | No        | qBittorrent data directory.                         | `"/var/lib/qbt/data"`                                       | `"/mnt/drive/qbt"`                   |
| `VARS_NETWORK_QBT_PORT`                   | No        | qBittorrent webui (loopback) port.                  | `"8080"`                                                    | `"20006"`                            |
| `VARS_NETWORK_JELLYFIN_ENABLE`            | No        | Enable Jellyfin.                                    | `"false"`                                                   | `"true"`                             |
| `VARS_NETWORK_JELLYFIN_PORT`              | No        | Jellyfin web (loopback) port.                       | `"8096"`                                                    | `"20007"`                            |
| `SECRETS_HASHED_PASSWORD`                 | No        | Hashed user password.                               | `$(mkpasswd -m yescrypt)`                                   | -                                    |
| `SECRETS_PSK`                             | No        | PSK for the network.                                | (user input)                                                | `"supersecretpsk"`                   |
| `SECRETS_DUCKDNS_TOKEN`                   | **Yes**   | DuckDNS API token.                                  | -                                                           | `"aaa..."`                           |
| `SECRETS_SEARXNG_KEY`                     | No        | SearXNG secret key.                                 | `"$(head -c 64 /dev/urandom | sha256sum | cut -d ' ' -f1)"` | `"bbb..."`                           |

Required section only shows the minimum variables needed to ensure a working system (ie, the rest will use defaults).

Ensure all variables are defined in the `$NIXOS_DIR/vars/vars.nix` and secrets in `$NIXOS_DIR/vars/secrets.yaml`.

## 4. Further setup.

#### 1. nginx

The nginx web server is hosted at `https://<your-duckdns-domain>`.

Reverse proxy:

|                   |                         |                             |
|-------------------|-------------------------|-----------------------------|
| `/searxng`        | SearXNG                 | Search engine               |
| `/vaultwarden`    | Vaultwarden web vault   | Password manager            |
| `/i2pd`           | I2PD web console        | Invisible Internel Protocol |
| `/qbt`            | qBittorrent webui       | Bittorrent client           |
| `/jellyfin`       | Jellyfin                | Media server                |

#### 2. qBittorrent

qBittorrent will initially start with username `admin` and a random password. Check the service status for the password.

```console
$ systemctl status qbt
```

Then, in the web ui `https://<your-duckdns-domain>/qbt` under `Tools > Options > WebUI > Authentication` set a username and password.

#### 3. Jellyfin

Access the web interface at `https://<your-duckdns-domain>/jellyfin` and follow the wizard to set up your user and library.

##### Disabling media playback

If using only the `Download` and/or `Copy Stream URL` options, you can disable media playback by disallowing it for your user.

Access the web interface at `https://<your-duckdns-domain>/jellyfin`, uncheck `Allow media playback` under `Dashboard > Users > <your-user> > Profile > Media Playback` and click `Save` at the end of the page.

## 5. Adding LUKS encrypted devices

Keyfile encrypted LUKS devices can be set up via `vars.nix`

Modify the `device.luks` variable under `DEVICE VARIABLES` in `vars.nix`

```console
$ nixos edit vars
```

For example, to set up two devices `ht02` and `ht03`:

```nix
  device.luks = [
    {
        name = "ht02";
        uuid = "3f74d2e3-5a67-4b86-b2c3-842f39e45b7a";
        id = "usb-Hitachi_192939485710293857281029-0:0";
        keyfile = "/root/keys/ht02";
        mount = "/mnt/ht02";
        fs = "xfs";
        hdparm = false;
    }
    {
        name = "ht03";
        uuid = "5a67d2e3-842f-3f74-b2c3-4b8639e45b7a";
        id = "usb-Samsung_110011002933881992003918-0:0";
        keyfile = "/root/keys/ht03";
        mount = "/mnt/ht03";
        fs = "ext4";
        hdparm = false;
    }
  ];
```
