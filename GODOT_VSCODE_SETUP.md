# Connecting Godot 4 to VS Code (or Cursor / Any VS Code Fork)

> **Why bother?** Godot's built-in script editor works fine, but if you already live in VS Code, you get multi-monitor support, your familiar keybindings, extensions you already know, better git integration, and the massive VS Code plugin ecosystem. This setup works with Cursor, Windsurf, or any VS Code fork — just swap the executable path.

---

## Step 1: Install the VS Code Extension

Open VS Code and install these extensions from the Extensions sidebar (`Ctrl+Shift+X`):

| Extension | ID | Purpose |
|-----------|----|---------|
| **Godot Tools** (required) | `geequlim.godot-tools` | GDScript language support, IntelliSense, debugger |
| **GDScript Formatter** (recommended) | search "GDScript Formatter" | Auto-format on save |
| **Godot Files** (optional) | search "Godot Files" | Better syntax highlighting for `.gdshader`, `.tres`, `.tscn` |

> **Cursor / other forks:** These extensions should install the same way. If the marketplace differs, you can download the `.vsix` from the [GitHub releases](https://github.com/godotengine/godot-vscode-plugin/releases) and install manually via `Extensions > ... > Install from VSIX`.

---

## Step 2: Tell Godot to Use VS Code as Its Script Editor

1. Open your Godot project
2. Go to **Editor > Editor Settings**
3. Navigate to **Text Editor > External**
4. Check **Use External Editor**
5. Set **Exec Path** to your editor's executable:

| Editor | Typical Path (Windows) |
|--------|----------------------|
| VS Code | `C:/Users/<you>/AppData/Local/Programs/Microsoft VS Code/bin/code.cmd` |
| Cursor | `C:/Users/<you>/AppData/Local/Programs/Cursor/bin/cursor.cmd` |
| VS Code (Linux) | Run `whereis code` in terminal to find it |
| VS Code (Mac) | `/Applications/Visual Studio Code.app/Contents/MacOS/Electron` |

6. Set **Exec Flags** to:
```
{project} --goto {file}:{line}:{col}
```

> This tells Godot to open VS Code at the exact file and line when you click a script.

---

## Step 3: Verify the Language Server Connection

The Godot Tools extension communicates with Godot's built-in language server (LSP) for IntelliSense, autocomplete, and error checking. **Godot must be running** for this to work.

1. In Godot, go to **Editor > Editor Settings > Network > Language Server**
2. Note the **Remote Host** (default: `127.0.0.1`) and **Remote Port** (default: `6005`)
3. In VS Code, open Settings (`Ctrl+,`) and search for `gdscript`
4. Confirm that **Gdscript_lsp_server_port** matches the port from Godot (usually `6005`)
5. If VS Code shows "Disconnected" in the bottom status bar, make sure Godot is open, then click **Retry**

When connected, you'll see GDScript IntelliSense working — autocomplete for built-in functions, type hints, and node paths.

---

## Step 4: Set Up Debugging (Run Games from VS Code)

1. In VS Code, open the **Run and Debug** panel (`Ctrl+Shift+D`)
2. Click **"create a launch.json file"**
3. Select **"GDScript Godot Debug"** from the dropdown
4. It will generate a `launch.json`. Here's a solid default config:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch Game",
            "type": "godot",
            "request": "launch",
            "project": "${workspaceFolder}",
            "port": 6006,
            "debugServer": 6006,
            "address": "127.0.0.1",
            "launch_game_instance": true,
            "launch_scene": false
        },
        {
            "name": "Launch Current Scene",
            "type": "godot",
            "request": "launch",
            "project": "${workspaceFolder}",
            "port": 6006,
            "debugServer": 6006,
            "address": "127.0.0.1",
            "launch_game_instance": true,
            "launch_scene": true
        }
    ]
}
```

5. In VS Code settings, search for **Godot Tools: Editor Path** and set it to the path of your Godot executable
6. Press **F5** to launch the game directly from VS Code

---

## Step 5: Quality of Life Settings

### In Godot (Editor Settings)

These prevent Godot and VS Code from fighting over file changes:

| Setting | Value | Location |
|---------|-------|----------|
| Auto Reload Scripts on External Change | **On** | Text Editor > Behavior > Files |
| Save on Focus Loss | **On** | Interface > Editor |
| Import Resources When Unfocused | **On** | Interface > Editor |

### In VS Code (User Settings)

| Setting | Value | Why |
|---------|-------|-----|
| `editor.formatOnSave` | `true` | Clean code automatically |
| `files.autoSave` | `afterDelay` | Prevents losing work |
| `files.associations` | `{"*.gd": "gdscript"}` | Ensures correct syntax highlighting |

---

## Important Gotchas

- **Godot must be running** for IntelliSense to work. The language server lives inside the Godot editor, not VS Code.
- **Never move or rename files in VS Code.** Always do it in the Godot FileSystem panel. Godot tracks resource references (signals, script links, scene paths) and will update them for you. Moving files in VS Code will break those links silently.
- **Use static typing in GDScript** for better autocomplete. The language server can't infer types from untyped code. Example:
  ```gdscript
  # Weak typing — LSP can't help much
  var speed = 200

  # Static typing — full autocomplete and error checking
  var speed: float = 200.0
  ```
- **If IntelliSense stops working**, try: close and reopen Godot, then use `Ctrl+Shift+P > Godot Tools: Open workspace with Godot editor` in VS Code.

---

## Headless LSP Mode (Godot 4.2+)

If you don't want to keep the full Godot editor open just for IntelliSense, Godot 4.2+ supports **headless LSP mode**. The VS Code extension can launch a windowless Godot instance in the background purely for language server features. To enable it:

1. In VS Code settings, search for **Godot Tools: Lsp > Headless**
2. Enable the headless mode toggle
3. Make sure the Godot executable path is set correctly

This is nice when you're just writing scripts and don't need the visual editor open.

---

## Quick Checklist

- [ ] VS Code: Install **Godot Tools** extension
- [ ] Godot: Set external editor to VS Code/Cursor executable
- [ ] Godot: Set exec flags to `{project} --goto {file}:{line}:{col}`
- [ ] Verify: Click a script in Godot → it opens in VS Code
- [ ] Verify: IntelliSense works (autocomplete shows Godot classes)
- [ ] Optional: Set up `launch.json` for F5 debugging
- [ ] Optional: Enable headless LSP mode (Godot 4.2+)
- [ ] Optional: Install GDScript Formatter for auto-formatting

---

*This guide works for VS Code, Cursor, Windsurf, or any VS Code fork. Just swap the executable path in Godot's editor settings.*
