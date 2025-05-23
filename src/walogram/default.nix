{
  pkgs,
  zip,
  imagemagick,
  image ? "",
  colors ? "",
  ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "walogram";
  version = "1.0";

  src = builtins.path {
    path = ./.;
    name = "source";
  };

  nativeBuildInputs = with pkgs; [ makeWrapper ];
  runtimeInputs = pkgs.lib.makeBinPath [
    zip
    imagemagick
  ];

  installPhase = ''
    # shellcheck disable=SC2154
    mkdir -p $out/bin
    mkdir -p $out/share

    # Install script and config
    cp bin/* $out/bin/
    chmod +x $out/bin/*

    cp share/* $out/share/

    substituteInPlace $out/bin/walogram --replace "# {{IMAGE}}" "IMAGE=\"${image}\""
    substituteInPlace $out/bin/walogram --replace "# {{COLORS}}" "${colors}"
  '';

  postFixup = ''
    wrapProgram $out/bin/walogram \
    --prefix PATH : ${runtimeInputs}
  '';

  meta = {
    mainProgram = "walogram";
    description = "walogram theme generator for telegram";
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ niksingh710 ];
  };
}
