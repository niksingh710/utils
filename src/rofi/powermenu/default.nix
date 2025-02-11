{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "rofi-powermenu";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.bash ];
  buildInputs = [ pkgs.coreutils pkgs.rofi-wayland ];

  installPhase = ''
    # shellcheck disable=SC2154
    mkdir -p "$out/bin"
    cp "$src/bin/menu" "$out/bin/rofi-powermenu"
    chmod +x "$out/bin/rofi-powermenu"

    # Copy non-executable data files
    mkdir -p "$out/share/"
    cp "$src"/share/* "$out/share/"
  '';

  meta = with pkgs.lib; {
    description = "Rofi powermenu with theme already handled";
    homepage = "https://github.com/niksingh710/utils";
    license = licenses.mit;
    maintainers = with maintainers; [ niksingh710 ];
    platforms = platforms.all;
  };
}
