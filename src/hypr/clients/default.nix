{ pkgs, rofi-theme-str ? "", ... }:

pkgs.stdenv.mkDerivation {
  pname = "clients";
  version = "1.0";

  src = ./.;

  buildInputs = with pkgs;[ rofi-wayland jq ];
  nativeBuildInputs = with pkgs;[ makeWrapper ];

  installPhase = ''
    # shellcheck disable=SC2154
    mkdir -p $out/bin
    mkdir -p $out/share

    # Install script and config
    cp bin/* $out/bin/
    chmod +x $out/bin/*

    cp share/* $out/share/

    # Create a wrapper to inject ROFI_THEME_STR
     wrapProgram $out/bin/run-focus --run "export ROFI_THEME_STR=\"${rofi-theme-str}\""
     wrapProgram $out/bin/get-client --run "export ROFI_THEME_STR=\"${rofi-theme-str}\""

  '';

  meta = {
    description = "Rofi menus to quick access for opened clients";
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ niksingh710 ];
  };
}
