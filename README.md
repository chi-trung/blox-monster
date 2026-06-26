# GnurtHub x Blox Monster

Script for the Roblox game **"[Bây giờ]Quái vật Blox"** (PlaceId `106763540857326`).

## Usage

Execute in any Roblox executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/chi-trung/blox-monster/main/loader.lua"))()
```

Or directly:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/chi-trung/blox-monster/main/source.lua"))()
```

## Features

- **Auto Catch** — auto-clicks the native catch button
- **Auto Hatch** — accelerates egg hatching
- **Auto Best Ball** — equips the ball with the highest catch multiplier
- **Teleport to Area Mobs** — cycles through Area1–Area8 and teleports you to the nearest mob
- **Menu toggle** — press `RightShift` to show/hide the UI

## Files

| File | Purpose |
|---|---|
| `source.lua` | Main script logic |
| `loader.lua` | Tiny loader that fetches `source.lua` |
| `README.md` | This file |

## Unload

The script exposes `GnurtHub.Unload()` in the global scope. Call it from the executor console to clean up.
