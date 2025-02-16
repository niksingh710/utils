{ pkgs, full-theme-str ? "", ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "menu";
  version = "1.0";

  src = ./.;

  # remove input if https://github.com/firecat53/networkmanager-dmenu/pull/153 is merged
  nativeBuildInputs = with pkgs;[ makeWrapper ];
  runtimeInputs = pkgs.lib.makeBinPath (with pkgs; [
    rofi-wayland
    killall
  ]);

  installPhase = ''
    # shellcheck disable=SC2154
    mkdir -p $out/bin
    mkdir -p $out/share

    # Install script and config
    cp bin/* $out/bin/
    chmod +x $out/bin/*

    cp share/* $out/share/

  '';

  postFixup = ''
    # Create a wrapper to inject ROFI_THEME_STR
    wrapProgram $out/bin/menu \
    --prefix PATH : ${runtimeInputs}

    substituteInPlace $out/share/full.rasi --replace "{{full-theme-str}}" "${full-theme-str}"
  '';

  meta = {
    description = "Rofi menus for fullscreen application launcher";
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ niksingh710 ];
  };
}
