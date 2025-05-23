{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "waybar-utils";
  version = "1.0";

  src = builtins.path {
    path = ./.;
    name = "source";
  };
  # remove input if https://github.com/firecat53/networkmanager-dmenu/pull/153 is merged
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  runtimeInputs = pkgs.lib.makeBinPath (
    with pkgs;
    [
      jq
      hyprpicker
      killall
      libnotify
      wl-screenrec
      slurp
    ]
  );

  installPhase = ''
    # shellcheck disable=SC2154
    mkdir -p $out/bin

    # Install script and config
    cp bin/* $out/bin/
    chmod +x $out/bin/*
  '';

  postFixup = ''
    # Create a wrapper to inject ROFI_THEME_STR
    wrapProgram $out/bin/recorder \
    --prefix PATH : ${runtimeInputs}
    wrapProgram $out/bin/colorpicker \
    --prefix PATH : ${runtimeInputs}
  '';

  meta = {
    description = "waybar screen recording script";
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ niksingh710 ];
  };
}
