# 🚀 Nix Scripts Flake

I realized that keeping all my scripts inside Nix `''` text objects made the code cluttered. So, I created this flake to manage my scripts more efficiently! 🎯

## 📦 Features
- **Easily Manageable**: Each script is stored as a separate file for clarity.
- **Hyprland Utilities**: Scripts to tweak Hyprland behavior dynamically.
- **Image Annotation**: Quick clipboard-based image annotation with Swappy.
- **Window Management**: Move, focus, and toggle windows seamlessly.
- **Volume & Brightness Controls**: Manage system volume and brightness with ease.
- **Quick Terminal for Hyprland**: Spawn a floating terminal instantly, like Yakuake.

## 📜 Installation
```sh
inputs.utils.url = "github:niksingh710/utils";

# In hyprland keymaps
",XF86AudioRaiseVolume,exec,${inputs.utils.packages.${pkgs.system}.volume} up"
",XF86AudioLowerVolume,exec,${inputs.utils.packages.${pkgs.system}.volume} down"

```
Or run scripts directly:
```sh
nix run github:niksingh710/utils#fast
nix run github:niksingh710/utils#zoom -- in
nix run github:niksingh710/utils#fullscreen
```

## 🛠 Available Scripts

| Script Name | Description |
|------------|-------------|
| [aerospace/aero.focus.sh](./src/aerospace/aero.focus.sh) | fzf menu to focus window or grab window to the current workspace  |
| [hypr/fast](./src/hypr/fast) | Toggles animations and rounding in Hyprland for a snappier experience. |
| [img-annotate](./src/img-annotate) | Opens Swappy to edit the image currently in clipboard. |
| [hypr/focus](./src/hypr/focus) | Handles focus between tiled and floating windows (like tabbed browsing). |
| [hypr/move](./src/hypr/move) | Moves tiled and floating windows; uses `HYPR_MOVE_VAL` to adjust movement. |
| [hypr/fullscreen](./src/hypr/fullscreen) | Toggles maximized and fullscreen states (`tiled/floating → maximized → fullscreen → tiled/floating`). |
| [hypr/zoom](./src/hypr/zoom) | Manages zoom levels (`in`, `out`, `reset`). |
| [hypr/toggle-group](./src/hypr/toggle-group) | Toggles a window into a Hyprland group; enables `Group` submap if already grouped. |
| [hypr/lid-down](./src/hypr/lid-down) | Handles laptop lid-down state. |
| [volume](./src/volume) | Supports `up`, `down`, `mute`, and `mic-mute` for volume control. |
| [brightness](./src/brightness) | Adjusts screen brightness using `brightnessctl`. |
| [cat](./src/cat) | Replaces cat command to use `bat` without paging and `-p` flag enables paging |
| [myip](./src/myip) | Shows local/global ip with flags `[-g,-l]`. |
| [hypr/quick-term](./src/hypr/quick-term) | Spawns a floating terminal in Hyprland, similar to Yakuake. |
| [hypr/monitor](./src/hypr/monitor) | Assigns 1-9 workspace to primary monitor and 10/0 to secondary (need help check comment in script) |
| [hypr/clients/run-focus](./src/hypr/clients) | Lists all opened clients in rofi and focus on them if also drun then, for colors you can override the theme e.g below.|
| [hypr/clients/get-client](./src/hypr/clients) | Lists all opened clients in rofi and brings them to the current workspace (ignores special workspace)|
| [rofi/menus/audio-sink](./src/rofi/menus) | Lists Speakers and present a rofi menu to switch default |
| [rofi/menus/audio-source](./src/rofi/menus) | Lists Microphones and present a rofi menu to switch default |
| [rofi/menus/rofimoji](./src/rofi/menus) | Emoji picker using rofi |
| [rofi/menus/network](./src/rofi/menus) | Quick network manager using rofi |
| [rofi/menus/bluetooth](./src/rofi/menus) | Quick bluetooth manager using rofi |
| [rofi/powermenu](./src/rofi/powermenu) | Rofi power manu isolatedly packed so that it will run from anywhere without needing the theme to be passed.|
| [waybar/recorder](./src/waybar/) | Screen Recording utility utilising wf-screenrec. Sends `RTMIN+4` Signal to waybar |
| [walogram](./src/walogram/) | Walogram to generate telegram theme from stylix/color palette |
| [center-align](https://github.com/niksingh710/center-align) | Logs the output in mid of terminal `echo hi \| center-align` |
| [bstat](https://github.com/niksingh710/basic-battery-stat) | Shows the battery status of system and mobile device if kdeconnect is connected |
| [audio-channel](./) | `fzf/rofi/dmenu` picker options to select default mic/output audio channel (will add as i complete my ndots) |

## 📖 Usage
For usage details, check out my **ndots** repository:
🔗 [ndots (Upcoming Refactor)](https://github.com/niksingh710/ndots)

### 🔧 Recommended Hyprland Config for Quick-Term
To quickly spawn a floating terminal in Hyprland, add the following keybind:
```hyprlang
"CTRL,grave,exec,${inputs.utils.packages.${pkgs.system}.quick-term}"
```
And apply these `windowrulev2` settings:
```hyprlang
"float, class:^(foot-quick)$"
"size 100% 40%, class:^(foot-quick)$"
"move 0% 60%, class:^(foot-quick)$"
"dimaround, class:^(foot-quick)$"
"noborder, class:^(foot-quick)$"
"rounding 0, class:^(foot-quick)$"
"noshadow, class:^(foot-quick)$"
"noanim,class:^(foot-quick)$"
"pin,class:^(foot-quick)$"
"stayfocused,class:^(foot-quick)$"
```

#### Walogram
```sh
nix run github:niksingh710/utils#walogram
```

Generated theme is at `~/.cache/stylix-telegram-theme/stylix.tdesktop-theme`

<details>
<summary>📸 Screenshots</summary>

![image](https://github.com/user-attachments/assets/22afed68-5ce7-4d1e-8866-3ad46f613a85)

</details>

To use it with stylix you can use the following snippet

```nix
{ pkgs, lib, inputs, config, ... }:
let
  walogram = inputs.utils.packages.${pkgs.system}.walogram.override {
    image = "${config.stylix.image}";
    colors = (with config.lib.stylix.colors;
      ''
        color0="#${base00}"
        color1="#${base01}"
        color2="#${base02}"
        color3="#${base03}"
        color4="#${base04}"
        color5="#${base05}"
        color6="#${base06}"
        color7="#${base07}"
        color8="#${base08}"
        color9="#${base09}"
        color10="#${base0A}"
        color11="#${base0B}"
        color12="#${base0C}"
        color13="#${base0D}"
        color14="#${base0E}"
        color15="#${base0F}"
      '');
  };
in
{
  home.packages = [ pkgs.materialgram ];
  home.activation.tg-theme = lib.hm.dag.entryAfter [ "" ]
    ''
      run ${lib.getExe walogram}
    '';
}
```

#### Rofi
##### Power Menu
```sh
nix run github:niksingh710/utils#powermenu-rofi
```

<details>
<summary>📸 Screenshots</summary>

![Image](https://github.com/user-attachments/assets/f7b40d4b-acc3-43c7-b67b-80b659e57432)

</details>

##### Emoji, Network, Bluetooth, Audio
```sh
nix run github:niksingh710/utils#menus
```

<details>
<summary>📸 Screenshots</summary>

![Image](https://github.com/user-attachments/assets/d73e211b-15be-44a0-82b9-db32be4fef30)

</details>

#### Clients
##### run-focus and get-client

```sh
nix shell -p github:niksingh710/utils#clients -c "run-focus"
```

This will make theming easy with stylix or other modules.

```nix
self.packages.clients.override ({
    rofi-theme-str = ''
        * {
            background: red;
        }
    '';
})
```

<details>
<summary>📸 Screenshots</summary>

| ![Image](https://github.com/user-attachments/assets/0a08444a-9532-44dc-b01b-bfc39d98d0eb) | ![Image](https://github.com/user-attachments/assets/71bdb445-6475-4283-8ba4-a5cd82b184d3) |
|-|-|

</details>

## 📊 Stats & Contributions

💡 Contributions, feedback, and ideas are welcome! 🎉 Feel free to open issues or PRs.

---
📝 **Made with ❤️ by [niksingh710](https://github.com/niksingh710)**
