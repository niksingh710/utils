{
  pkgs,
  choose-gui,
  fetchFromGitHub,
  font ? "Menlo",
  ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "aero.focus.choose";
  version = "1.0";

  src = builtins.path {
    path = ./.;
    name = "source";
  };

  nativeBuildInputs = with pkgs; [ makeWrapper ];
  runtimeInputs = pkgs.lib.makeBinPath [
    # TODO: after merger of <https://github.com/NixOS/nixpkgs/pull/423701> switch to that
    (choose-gui.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "chipsenkbeil";
        repo = "choose";
        rev = "1.5.0";
        hash = "sha256-ewXZpP3XmOuV/MA3fK4BwZnNb2jkE727Sse6oAd4HJk=";
      };
    }))
  ];

  installPhase = ''
    # shellcheck disable=SC2154
    mkdir -p $out/bin

    # Install script and config
    cp * $out/bin/
    chmod +x $out/bin/*

    substituteInPlace $out/bin/aero.focus.choose --replace-quiet "# {{font}}" "font=\"${font}\""
    substituteInPlace $out/bin/aero.grab.choose --replace-quiet "# {{font}}" "font=\"${font}\""
  '';

  postFixup = ''
    wrapProgram $out/bin/aero.focus.choose \
    --prefix PATH : ${runtimeInputs}

    wrapProgram $out/bin/aero.grab.choose \
    --prefix PATH : ${runtimeInputs}
  '';

  meta = {
    mainProgram = "aero.focus.choose";
    description = "aerospace scripts";
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ niksingh710 ];
  };
}
