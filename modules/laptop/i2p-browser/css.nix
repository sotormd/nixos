{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    programs.firefox.profiles."i2p" = {
      userContent = ''
        /* change homepage background color */
        @-moz-document url("about:newtab"), url("about:home") {
            :root[lwt-newtab-brighttext] {
              --newtab-background-color: #2e3440 !important;
            }
        }
      '';
      userChrome = ''
        /* hide real placeholder */
        #urlbar-input::placeholder {
            color: transparent !important;
        }

        /* hide firefox-view button */
        #firefox-view-button {
            display: none !important;
        }

        /* hide tab search button */
        #alltabs-button {
            display: none !important;
        }

        /* center text in urlbar */
        #urlbar-input {
            padding-left: 20px !important;
        }

        /* hide extensions button */
        #unified-extensions-button, #unified-extensions-button > .toolbarbutton-icon {
           width: 0px !important;
            padding: 0px !important;
        }

        /* hide bookmark button */
        #star-button-box {
            display: none !important;
        }

        /* hide picture in picture button */
        #picture-in-picture-button {
            display: none !important;
        }

        /* hide site identity buttons */
        #identity-box {
            display: none !important;
        }

        /* hide tracking protection button */
        #tracking-protection-icon-container {
            display: none !important;
        }

        /* hide reader mode button */
        #reader-mode-button {
            display: none !important;
        }

        /* hide go button */
        #urlbar .urlbar-go-button {
            display: none !important;
        }

        /* hide reload and stop button */
        #reload-button, #stop-button {
            display: none !important;
        }

        /* hide downloads button */
        #downloads-button {
            display: none !important;
        }

        /* hide tabs toolbar if there is only one tab */
        :root[sizemode="normal"] #nav-bar {
            --uc-window-drag-space-width: 20px
        }

        #titlebar {
            -moz-appearance: none !important;
        }

        #TabsToolbar {
            min-height: 0px !important;
        }

        #tabbrowser-tabs,
        #tabbrowser-arrowscrollbox {
            min-height: 0 !important;
        }

        .tabbrowser-tab:only-of-type,
        .tabbrowser-tab[first-visible-tab="true"][last-visible-tab="true"] {
            visibility: collapse !important;
            min-height: 0 !important;
            height: 0;
        }

        #tabbrowser-arrowscrollbox-periphery,
        #private-browsing-indicator-with-label {
            contain: strict;
            contain-intrinsic-height: 0px;
        }

        #tabbrowser-arrowscrollbox-periphery {
            contain-intrinsic-width: 36px;
            padding-inline-end: 3px;
        }

        #private-browsing-indicator-with-label {
            contain-intrinsic-width: 165px;
        }

        /* hide sidebar header and button */
        #sidebar-header, #sidebar-button {
            display: none !important;
        }

        /* font */
        #urlbar, #searchbar .searchbar-textbox {
            font-family: IBM Plex Sans !important;
        }
      '';
    };
  };
}
