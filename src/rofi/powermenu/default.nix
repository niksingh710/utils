{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "rofi-powermenu";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.bash ];
  buildInputs = [ pkgs.coreutils pkgs.makeWrapper ];
  runtimeInputs = pkgs.lib.makeBinPath (with pkgs;[ rofi-wayland killall ]);

  installPhase = ''
    # shellcheck disable=SC2154
    mkdir -p "$out/bin"
    cp "$src/bin/menu" "$out/bin/rofi-powermenu"
    chmod +x "$out/bin/rofi-powermenu"
    # Copy non-executable data files
    mkdir -p "$out/share/"
    cp "$src"/share/* "$out/share/"
  '';

  postFixup = ''
    # Wrap the script to include dependencies in PATH
    wrapProgram "$out/bin/rofi-powermenu" \
      --prefix PATH : ${runtimeInputs}
  '';

  meta = with pkgs.lib; {
    description = "Rofi powermenu with theme already handled";
    homepage = "https://github.com/niksingh710/utils";
    license = licenses.mit;
    mainProgram = "menu";
    maintainers = with maintainers; [ niksingh710 ];
    platforms = platforms.all;
  };
}
