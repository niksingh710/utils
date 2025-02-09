{
  description = "Utility scripts to be used by my NixOS configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, lib, ... }:
        let
          mkShellApplication = name: runtimeInputs: text: pkgs.writeShellApplication {
            inherit name text runtimeInputs;
          };
        in
        {
          packages = {
            fast = mkShellApplication
              "fast" [ pkgs.jq ]
              (builtins.readFile ./src/hypr/fast);

            img-annotate = mkShellApplication
              "img-annotate"
              (with pkgs;[ libnotify wl-clipboard swappy ])
              (builtins.readFile ./src/img-annotate);

            focus = mkShellApplication
              "focus"
              (with pkgs;[ jq ])
              (builtins.readFile ./src/hypr/focus);

            move = mkShellApplication
              "move"
              (with pkgs;[ jq ])
              (builtins.readFile ./src/hypr/move);

            fullscreen = mkShellApplication
              "fullscreen"
              (with pkgs;[ jq ])
              (builtins.readFile ./src/hypr/fullscreen);

            zoom = mkShellApplication
              "zoom"
              (with pkgs;[ jq bc ])
              (builtins.readFile ./src/hypr/zoom);

            toggle-group = mkShellApplication "toggle-group" (with pkgs;[ jq libnotify ])
              (builtins.readFile ./src/hypr/toggle-group);

            lid-down = mkShellApplication
              "lid-down"
              (with pkgs;[ jq ])
              (builtins.readFile ./src/hypr/lid-down);

            volume = mkShellApplication
              "volume"
              (with pkgs;[ bc jq gawk libnotify ])
              (builtins.readFile ./src/volume);

            brightness = mkShellApplication
              "brightness"
              (with pkgs;[ libnotify brightnessctl ])
              (builtins.readFile ./src/brightness);

            quick-term = mkShellApplication
              "quick-term"
              (with pkgs;[ foot jq tmux ])
              (builtins.readFile ./src/hypr/quick-term);
          };
        };
    };
}
