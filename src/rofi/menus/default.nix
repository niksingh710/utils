{ pkgs, inputs, audio-theme-str ? "", network-theme-str ? "", bt-theme-str ? "", uwsm ? false, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "menus";
  version = "1.0";

  src = ./.;

  # remove input if https://github.com/firecat53/networkmanager-dmenu/pull/153 is merged
  nativeBuildInputs = with pkgs;[ makeWrapper ];
  runtimeInputs = pkgs.lib.makeBinPath (with pkgs; [
    (rofi-wayland.overrideAttrs (oldAttrs: {
      postFixup = (oldAttrs.postFixup or "") + (
        pkgs.lib.optionalString uwsm ''
          wrapProgram $out/bin/rofi -a "run" --add-flags "-run-command 'uwsm app -- {cmd}'"
        ''
      );
    }))
    jq
    killall
    libnotify
    rofi-bluetooth
    rofimoji
    inputs.networkmanager.packages.${pkgs.system}.default
  ]);

  network-theme = builtins.replaceStrings [ "\n" ] [ " " ] network-theme-str;
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
    wrapProgram $out/bin/bluetooth \
    --prefix PATH : ${runtimeInputs}

    wrapProgram $out/bin/audio-sink \
    --run "export ROFI_THEME_STR=\"${audio-theme-str}\"" \
    --prefix PATH : ${runtimeInputs}

    wrapProgram $out/bin/audio-source \
    --run "export ROFI_THEME_STR=\"${audio-theme-str}\"" \
    --prefix PATH : ${runtimeInputs}

    wrapProgram $out/bin/rofimoji \
    --prefix PATH : ${runtimeInputs}

    wrapProgram $out/bin/network \
    --run "export NM_DMENU_CONFIG="$out/share/nm.ini"" \
    --run "export ROFI_THEME_STR=\"${network-theme-str}\"" \
    --prefix PATH : ${runtimeInputs}

    substituteInPlace $out/share/nm.ini --replace "{{config}}" "$out/share/conf.rasi"
    substituteInPlace $out/share/nm.ini --replace "{{network-theme-str}}" "\"${network-theme}\""
    substituteInPlace $out/share/bt.rasi --replace "{{bt-theme-str}}" "${bt-theme-str}"
  '';

  meta = {
    description = "Rofi menus for utility items";
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ niksingh710 ];
  };
}
