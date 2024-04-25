# bypass.yazi

[Yazi](https://github.com/sxyazi/yazi) plugin for bidirectional skipping of directories which only have a single subdirectory

> [!NOTE]
> This might be a little inconsistent for now as I'm currently using a (lazy) workaround to `Yazi`, for the time being, not having a way to tell if a directory is loaded. This will be fixed with `Yazi v0.2.6`.

<https://github.com/Rolv-Apneseth/bypass.yazi/assets/69486699/5487537b-fe01-40e9-bc34-4d1116b491b5>

## Requirements

- [Yazi](https://github.com/sxyazi/yazi) v0.2.4+

## Installation

### Linux / MacOS

```sh
git clone https://github.com/Rolv-Apneseth/bypass.yazi.git ~/.config/yazi/plugins/bypass.yazi
```

### Windows

```sh
git clone https://github.com/Rolv-Apneseth/bypass.yazi.git %AppData%\yazi\config\plugins\bypass.yazi
```

## Usage

Add this to your `keymap.toml`:

```toml
[[manager.prepend_keymap]]
on = [ "L" ]
run = "plugin bypass"
desc = "Recursively enter child directory, skipping children with only a single subdirectory"
[[manager.prepend_keymap]]
on = [ "H" ]
run = "plugin bypass --args=reverse"
desc = "Recursively enter parent directory, skipping parents with only a single subdirectory"
```

And that's it. You can bind any key you like, including overriding the default `enter` and `leave` bindings by setting them to `l` and `h` respectively.

Note that  if you're using the [smart enter tip](https://yazi-rs.github.io/docs/tips#smart-enter) from the documentation, this plugin can replace that entirely by using this keybind instead:

```toml
[[manager.prepend_keymap]]
on = [ "l" ]
run = "plugin bypass --args=smart_enter"
desc = "Open a file, or recursively enter child directory, skipping children with only a single subdirectory"
```
