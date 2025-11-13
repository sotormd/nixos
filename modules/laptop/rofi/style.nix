{ pkgs, colors, ... }:

{
  style = pkgs.writeTextFile {
    name = "style.rasi";
    text = ''
      /*****----- Configuration -----*****/
      configuration {
        modes:                      [run];
        show-icons:                 false;
        display-run:                "󱓞";
      }


      /*****----- Global Properties -----*****/
      * {
          font:                        "${colors.fonts.normal} 11";
          border-colour:               #${colors.blue2};
          handle-colour:               #${colors.blue2};
          background-colour:           #${colors.bg3};
          foreground-colour:           #${colors.fg0};
          alternate-background:        #${colors.bg2};
          normal-background:           #${colors.bg3};
          normal-foreground:           #${colors.fg0};
          urgent-background:           #${colors.yellow};
          urgent-foreground:           #${colors.bg3};
          active-background:           #${colors.green};
          active-foreground:           #${colors.bg3};
          selected-normal-background:  #${colors.blue2};
          selected-normal-foreground:  #${colors.bg3};
          selected-urgent-background:  #${colors.green};
          selected-urgent-foreground:  #${colors.bg3};
          selected-active-background:  #${colors.yellow};
          selected-active-foreground:  #${colors.bg3};
          alternate-normal-background: #${colors.bg3};
          alternate-normal-foreground: #${colors.fg0};
          alternate-urgent-background: #${colors.yellow};
          alternate-urgent-foreground: #${colors.bg3};
          alternate-active-background: #${colors.green};
          alternate-active-foreground: #${colors.bg3};
      }

      /*****----- Main Window -----*****/
      window {
          /* properties for window widget */
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       350px;
          height:                      30%;
          x-offset:                    0px;
          y-offset:                    0px;

          /* properties for all widgets */
          enabled:                     true;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               7px;
          border-color:                @border-colour;
          cursor:                      "default";
          /* Backgroud Colors */
          background-color:            @background-colour;
          /* Backgroud Image */
          //background-image:          url("/path/to/image.png", none);
          /* Simple Linear Gradient */
          //background-image:          linear-gradient(red, orange, pink, purple);
          /* Directional Linear Gradient */
          //background-image:          linear-gradient(to bottom, pink, yellow, magenta);
          /* Angle Linear Gradient */
          //background-image:          linear-gradient(45, cyan, purple, indigo);
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     20px;
          margin:                      0px;
          padding:                     20px;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                @border-colour;
          background-color:            transparent;
          children:                    [ "inputbar", "message", "listview"];
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     8px;
          border:                      0px solid;
          border-radius:               4px;
          border-color:                @border-colour;
          background-color:            @alternate-background;
          text-color:                  @foreground-colour;
          children:                    [ "prompt", "entry" ];
      }

      prompt {
          enabled:                     true;
          background-color:            inherit;
          text-color:                  inherit;
      }
      textbox-prompt-colon {
          enabled:                     true;
          expand:                      false;
          str:                         "";
          background-color:            inherit;
          text-color:                  inherit;
      }
      entry {
          enabled:                     true;
          background-color:            inherit;
          text-color:                  var(foreground-colour);
          cursor:                      text;
          placeholder:                 "start typing to search";
          placeholder-color:           inherit;
      }
      num-filtered-rows {
          enabled:                     true;
          expand:                      false;
          background-color:            inherit;
          text-color:                  inherit;
      }
      textbox-num-sep {
          enabled:                     true;
          expand:                      false;
          str:                         "/";
          background-color:            inherit;
          text-color:                  inherit;
      }
      num-rows {
          enabled:                     true;
          expand:                      false;
          background-color:            inherit;
          text-color:                  inherit;
      }
      case-indicator {
          enabled:                     true;
          background-color:            inherit;
          text-color:                  inherit;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          columns:                     1;
          lines:                       10;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                true;
          fixed-columns:               true;

          spacing:                     5px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @border-colour;
          background-color:            transparent;
          text-color:                  @foreground-colour;
          cursor:                      "default";
      }
      scrollbar {
          handle-width:                5px ;
          handle-color:                @handle-colour;
          border-radius:               8px;
          background-color:            @alternate-background;
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          spacing:                     8px;
          margin:                      0px;
          padding:                     8px;
          border:                      0px solid;
          border-radius:               4px;
          border-color:                @border-colour;
          background-color:            transparent;
          text-color:                  @foreground-colour;
          cursor:                      pointer;
      }
      element normal.normal {
          background-color:            var(normal-background);
          text-color:                  var(normal-foreground);
      }
      element normal.urgent {
          background-color:            var(urgent-background);
          text-color:                  var(urgent-foreground);
      }
      element normal.active {
          background-color:            var(active-background);
          text-color:                  var(active-foreground);
      }
      element selected.normal {
          background-color:            var(selected-normal-background);
          text-color:                  var(alternate-background);
      }
      element selected.urgent {
          background-color:            var(selected-urgent-background);
          text-color:                  var(selected-urgent-foreground);
      }
      element selected.active {
          background-color:            var(selected-active-background);
          text-color:                  var(selected-active-foreground);
      }
      element alternate.normal {
          background-color:            var(alternate-normal-background);
          text-color:                  var(alternate-normal-foreground);
      }
      element alternate.urgent {
          background-color:            var(alternate-urgent-background);
          text-color:                  var(alternate-urgent-foreground);
      }
      element alternate.active {
          background-color:            var(alternate-active-background);
          text-color:                  var(alternate-active-foreground);
      }
      element-icon {
          background-color:            transparent;
          text-color:                  inherit;
          size:                        24px;
          cursor:                      inherit;
      }
      element-text {
          background-color:            transparent;
          text-color:                  inherit;
          highlight:                   inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.0;
      }

      /*****----- Message -----*****/
      message {
          enabled:                     true;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                @border-colour;
          background-color:            transparent;
          text-color:                  @foreground-colour;
      }
      textbox {
          padding:                     8px;
          border:                      0px solid;
          border-radius:               4px;
          border-color:                @border-colour;
          background-color:            @alternate-background;
          text-color:                  @foreground-colour;
          vertical-align:              0.5;
          horizontal-align:            0.0;
          highlight:                   none;
          placeholder-color:           @foreground-colour;
          blink:                       true;
          markup:                      true;
      }
      error-message {
          padding:                     10px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @border-colour;
          background-color:            @background-colour;
          text-color:                  @foreground-colour;
      }
    '';
    destination = "/style.rasi";
  };

}
