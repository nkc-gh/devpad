# Contributing

Rules for contributing developer concepts, notes, and configs to this repository.

## Commit Messages

Use this format:

```text
<Action>: [<file or directory>]

<description of the change>

- 
- 
```

### Actions

| Action | Use |
| --- | --- |
| `Add` | Add a new concept, note, or config file |
| `Update` | Update existing notes or configurations |
| `Fix` | Fix mistakes, broken commands, or typos |
| `Remove` | Delete old or unused files |

### Examples

```text
Add: [configs/fish/config.fish]

- Added Fish shell configuration.

Update: [configs/wezterm/wezterm.lua]

- Insert shortcuts pane split keybindings.

Fix: [version_control/git_cmds.md]

- Fixed credential helper command.

Remove: [configs/auto-cpufreq/old-config.conf]

- Deleted unused configuration file.
```

**When changing multiple files in one commit , use this format :**

```text
Update: [version_control/git_cmds.md, README.md ; Configs/README.md]

- Insert new branch management section to git_cmds.md.
- Added README.md for version_control/.
- Added README.md for Configs/.
```

**Commit Rules:**
- Keep commits small and focused on a single change.
- Keep the first line short and direct.
- Use bullet points for additional details if needed.

## File Naming

- Use **snake_case** for filenames .
- Examples:
  - `version_control/git_cmds.md`
  - `configs/wezterm/wezterm.lua`
  - `configs/fish/config.fish`
  - `configs/auto-cpufreq/auto-cpufreq.conf`
  - `docker/docker_commands.md`

## Documentation Rules

- **Explain commands using comments**: Add comments (`#`, `--`, etc.) next to or directly above commands to explain what they or their flags do.
  
  Example:
  ```bash
  git config --global user.name "username" # sets default name used across all repos
  git config --system --list # lists system-wide settings from /etc/gitconfig
  ```

- **Direct and simple**: Keep explanations brief and to the point.
- **No secrets**: Never commit private keys, passwords, or personal credentials.
