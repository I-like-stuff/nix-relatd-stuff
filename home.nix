{ config, pkgs, inputs, lib, ... }:
 let
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ash_17";
  home.homeDirectory = "/home/ash_17";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;    
  home.packages = with pkgs; [  inputs.webcord.packages.${pkgs.system}.default ];  

  # allow spotify to be installed if you don't have unfree enabled already
   nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
 
    programs.spicetify =
      let
     officialThemesOLD = pkgs.fetchgit {
      url = "https://github.com/spicetify/spicetify-themes";
      rev = "c2751b48ff9693867193fe65695a585e3c2e2133";
      sha256 = "0rbqaxvyfz2vvv3iqik5rpsa3aics5a7232167rmyvv54m475agk";
   };    
       localFilesSrc = pkgs.fetchgit {
        url = "https://github.com/hroland/spicetify-show-local-files/";
        rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
        sha256 = "01gy16b69glqcalz1wm8kr5wsh94i419qx4nfmsavm4rcvcr3qlx";
    };
  in 
    {
        spotifyPackage = pkgs.spotify-unwrapped;
        spicetifyPackage = pkgs.spicetify-cli.overrideAttrs (oa: rec {
        pname = "spicetify-cli";
        version = "2.9.9";
        src = pkgs.fetchgit {
          url = "https://github.com/spicetify/${pname}";
          rev = "v${version}";
          sha256 = "1a6lqp6md9adxjxj4xpxj0j1b60yv3rpjshs91qx3q7blpsi3z4z";
       };
    });
        enable = true;
        theme = {
        name = "Dribbblish";
        src = officialThemesOLD;
        requiredExtensions = [
      {
           filename = "dribbblish.js";
            src = "${officialThemesOLD}/Dribbblish";
          }
       ];
        appendName = true;
       patches = {
          "xpui.js_find_8008" = ",(\\w+=)32,";
          "xpui.js_repl_8008" = ",$\{1}56,";
        };
         injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        sidebarConfig = true;
      };
        colorScheme = "custom";
        customColorScheme = {
        text = "ebbcba";
        subtext = "F0F0F0";
        sidebar-text = "e0def4";
        main = "191724";
        sidebar = "2a2837";
        player = "191724";
        card = "191724";
        shadow = "1f1d2e";
        selected-row = "797979";
        button = "31748f";
        button-active = "31748f";
        button-disabled = "555169";
        tab-active = "ebbcba";
        notification = "1db954";
        notification-error = "eb6f92";
        misc = "6e6a86";
      };
        enabledCustomApps = with spicePkgs.apps; [
        new-releases
        {
          name = "localFiles";
          src = localFilesSrc;
          appendName = false;
        }
    ];
           enabledExtensions = with spicePkgs.extensions; [
        playlistIcons
        lastfm
        genre
        historyShortcut
        hidePodcasts
        fullAppDisplay
        shuffle
      ];
    };
}
