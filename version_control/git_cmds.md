# Git Commands

## topics

- [How to Install Git on different machines](#how-to-install-git-on-different-machines)
- [Git Config](#git-config)
- [Turning a Folder into a Git Repo](#turning-a-folder-into-a-git-repo)
- [Git Add](#git-add)
- [Git Commit](#git-commit)

## How to Install Git on different machines

### Ubuntu
```bash
sudo apt update
sudo apt install git
```

## Git Config

There are 3 levels of config. If the same setting exists at more than one level, **local wins over global, global wins over system.**

- **System** — one shared file for every OS user on the machine. Rarely touched on a personal computer. Needs `sudo`.
- **Global** — one file for my own user account. This is my default identity, used everywhere unless overridden.
- **Local** — lives inside one specific repo's `.git/config`. Only applies to that one folder. Used when a project needs a different identity (e.g. GitHub as default, but this one folder pushes to GitLab).

### Set System Config
```bash
sudo git config --system user.name "Shared Name"
sudo git config --system user.email "shared@example.com"
```
Check it:
```bash
git config --system --list
```

### Set Global Config
```bash
git config --global user.name "username"
git config --global user.email "you@example.com"
```
Check it:
```bash
git config --global --list
```

### Set Local Config
Run this *inside* the repo folder (no `--global` flag = applies only here):
```bash
git config user.name "Your Other Name"
git config user.email "you@other-email.com"
```
Check it:
```bash
git config --list --local
```

**Note on local:** it only exists inside that one repo's `.git/config`. There's no command to list all local configs across every folder at once — I have to `cd` into each repo and check individually.

**Note on system/global:** both are a single file each (not per-folder), so they can be checked from anywhere:
- System → `/etc/gitconfig`
- Global → `~/.gitconfig`

### Which config is actually active right now?

```bash
git config user.email
```
This gives **one value** — whichever email git will actually use if I commit right now, in this exact folder. Priority: local > global > system. If global is `github@email.com` but local here is `gitlab@email.com`, this prints `gitlab@email.com` — local wins. Global still exists, just isn't used in this folder.

Outside any repo (e.g. home dir), there's no local to override, so it just shows global.

```bash
git config --show-origin user.email
```
Same winning value, but also shows the **file path** it came from — so I can see if it's from `.git/config` (local) or `~/.gitconfig` (global).

Example:
```
file:/home/user/project/.git/config    gitlab@email.com
```

```bash
git config --list --show-origin
```
Shows **everything** — every config key active for this repo (name, email, editor settings, aliases, all of it), system + global + local merged, each tagged with its source file. Order shown is system → global → local (not by priority) — so local always appears **last** in the list, even though it's the one that wins.

### Config vs Remote — two different questions

Setting the right email doesn't control **where** `git push` sends code. Those are two completely separate things:

| Question | Command | What it tells me |
|---|---|---|
| Who gets credited on my commits? | `git config user.email` | The email attached to commits made here |
| Where does my code actually get pushed? | `git remote -v` | The actual GitHub/GitLab URL this repo pushes to |

```bash
git remote -v
```
Example output:
```bash
origin https://gitlab.com/username/repo.gi (fetch)
origin https://gitlab.com/username/repo.git (push)
```
**Why check both:** if two different accounts (or me, on two machines) contribute to the same repo, each person's commits get tagged with whatever `user.email` was set on *their* machine — git doesn't cross-check the email against the remote or the account logged in. So to know the full picture — who I'll be credited as, and where the code is going — I check both commands together, standing inside the folder in question.

### `includeIf` — auto-switching identity by folder path

Still technically part of **global** config — no second global file is created. It just tells git: "if I'm inside this folder path, load these extra settings automatically." Saves manually setting local config in every new repo.

Example — auto-use GitLab identity for anything inside `~/gitlab-projects/`:

```bash
# inside ~/.gitconfig
[user]
    name = Your GitHub Name
    email = you@github-email.com

[includeIf "gitdir:~/gitlab-projects/"]
    path = ~/.gitconfig-gitlab
```

```bash
# separate file: ~/.gitconfig-gitlab
[user]
    name = Your GitLab Name
    email = you@gitlab-email.com
```

Now every repo created inside `~/gitlab-projects/` automatically uses the GitLab identity — no manual local config needed per folder.

### Storing Password in .gitconfig

You can store your GitHub Personal Access Token (PAT) so `git push` stops asking for it every time.

**Set the credential helper**
```bash
git config --global credential.helper store
```
Next `git push`, enter your PAT as the password — git saves it in plain text at `~/.git-credentials`, and won't ask again.

**Variations**

```bash
git config --global credential.helper cache
```
Keeps it only in memory, temporarily (default 15 min), never written to disk.

```bash
git config --global credential.helper "cache --timeout=3600"
```
Same as above, custom timeout in seconds (here, 1 hour).

```bash
git config --global credential.helper libsecret
```
Uses GNOME Keyring — encrypted, more secure than `store`. Needs:
```bash
sudo apt install libsecret-1-0 libsecret-1-dev
```

**Switching helpers** — just re-run the command with a new value, it overwrites the old setting. Note: switching away from `store` doesn't delete the old plain-text file — remove it manually if needed:
```bash
rm ~/.git-credentials
```

**Check current helper**
```bash
git config --global credential.helper
```
Only prints the helper name (e.g. `store`) — never the actual token. The token itself lives in `~/.git-credentials` (if using `store`) — never share or commit that file.

## Turning a Folder into a Git Repo

### Approach 1: Start local, connect to online repo after

**Step 1 — make the folder a repo**
```bash
mkdir my-project
cd my-project
git init
```
This creates a hidden `.git/` folder inside — that's what actually tracks everything. At this point it's fully local, nothing online yet.

**Step 2 — create an empty repo online**
Go to GitHub/GitLab, create a new empty repo (no README, no files), copy its URL.

**Step 3 — connect local folder to that online repo**
```bash
git remote add origin https://github.com/username/repo.git
```

---

### Approach 2: Clone an already-existing online repo

If the repo already exists online:
```bash
git clone https://github.com/username/repo.git
```
This downloads it and sets it up as a local repo **with the remote already linked** — no `git init` or `git remote add` needed, clone does both automatically.

## Git Add
 
Git tracks files in 3 states:
 
```
Working Directory  →  Staging Area  →  Repository (committed)
   (my edits)           (git add)         (git commit)
```
 
`git add` takes a **snapshot** of a file exactly as it is right now, and puts that snapshot in the staging area, ready for the next commit.
 
**Important:** it's not "mark this file as tracked forever" — it's a snapshot at that exact moment. If I edit the file again *after* staging it, that newer change is NOT included — I'd need to `git add` again to stage the newer version too. `git commit` only commits whatever is currently in the staging area, not whatever the file looks like on disk right now.
 
```bash
git status
```
Shows both states clearly if they differ — what's staged vs what's changed since staging. Good habit to run before every commit.
 
### Why staging is actually useful
 
If I fix a bug and also clean up unrelated code in the same session, I don't want both changes in one commit — a clean history means one commit = one logical change, so if something breaks later, I know exactly which commit caused it.
 
```bash
git add bugfix_file.py
git commit -m "fix: handle null pointer in login flow"
 
git add cleanup_file.py
git commit -m "chore: remove debug print statement"
```
 
Even inside the *same file*, if it has two unrelated changes:
```bash
git add -p file.py
```
Lets me pick which parts (hunks) go into which commit, instead of dumping everything together.
 
### Common `git add` variations
 
```bash
git add filename.txt      # stage one specific file
git add .                 # stage everything changed in current folder + subfolders
git add -A                # stage everything changed in the whole repo, including deletions
git add *.py               # stage all .py files in current folder
git add -p filename.txt   # interactive: stage only specific lines/chunks of a file
```
 
For 2 files where I only want to stage part of each:
```bash
git add -p file1.txt
git add -p file2.txt
```
Each opens its own interactive session — no single command does "partial lines across multiple files" at once.
 
### Deleting files and `git add`
 
If a tracked file gets deleted (via `rm`, file manager, etc.), git just sees it as "missing" — same as any other unstaged change:
```bash
rm file.txt
git status   # shows: deleted: file.txt
```
 
`git add -A` (or `git add file.txt`) stages that deletion too — confirming "remove this file in the next commit."
 
Note: OS-level Trash/Recycle Bin is unrelated to git — git only checks if the file is physically present in the folder, not whether the OS kept a backup copy somewhere.
 
Git's own shortcut — deletes + stages in one step:
```bash
git rm file.txt
```
 
 ## Git Commit

`git commit` takes whatever is currently staged and saves it permanently as a snapshot in the project's history. Each commit records what changed, who made it (from config), when (automatic timestamp), and why (the message I write).

```bash
git commit -m "message"
```

**Important:** commit only saves what's staged — not whatever the file currently looks like on disk. If a change wasn't staged with `git add`, it won't be in the commit, no matter what the file looks like now.

### Commands

```bash
git commit -m "message"              # commit staged changes with a message
git commit                           # opens editor to write a longer message
git commit -am "message"             # stage all TRACKED file changes + commit in one step (won't catch brand new untracked files, but DOES catch deletions of tracked files)
git commit --amend                   # edit the most recent commit (message or forgotten files)
git commit --amend --no-edit         # amend but keep the exact same message (skips editor)
git commit --allow-empty -m "message" # commit with no file changes at all (e.g. to trigger CI/CD)
git commit -v                        # opens editor with the diff shown alongside, as reference while writing the message
```

### `--amend` in detail

Used right after committing, to fix a mistake instead of making a whole new separate commit.

**Fix a typo in the message:**
```bash
git commit --amend -m "corrected message"
```

**Forgot to include a file:**
```bash
git add forgotten_file.py
git commit --amend
```
This merges the forgotten file into the same commit as before, instead of creating a new one for something that logically belongs together.

**How it actually works:** `--amend` doesn't edit the old commit in place — it creates a **new commit that replaces the old one** (new hash). Git makes it look like a clean rewrite instead of having two messy commits.

**Warning:** only amend commits that are still local/unpushed. If already pushed and someone else pulled it, amending changes the commit's identity and causes conflicts for others who have the old version. Safe before `git push`, risky after.

## Git Commit

`git commit` takes whatever is currently staged and saves it permanently as a snapshot in the project's history. Each commit records what changed, who made it (from config), when (automatic timestamp), and why (the message I write).

```bash
git commit -m "message"
```

**Important:** commit only saves what's staged — not whatever the file currently looks like on disk. If a change wasn't staged with `git add`, it won't be in the commit, no matter what the file looks like now.

### All commit commands

```bash
git commit -m "message"               # commit staged changes with a message
git commit                            # opens editor to write a longer message
git commit -am "message"              # stage all TRACKED file changes + commit in one step (won't catch brand new untracked files, but DOES catch deletions of tracked files)
git commit --amend                    # edit the most recent commit (message or forgotten files)
git commit --amend -m "message"       # amend and set a new message directly
git commit --amend --no-edit          # amend but keep the exact same message (skips editor)
git commit --allow-empty -m "message" # commit with no file changes at all
git commit -v                         # opens editor with the diff shown alongside, as reference while writing the message
git commit -S -m "message"            # GPG-sign the commit
git commit --fixup <commit>           # mark this as a fix for an earlier commit (used with interactive rebase)
```

### `--amend` in detail

Used right after committing, to fix a mistake instead of making a whole new separate commit.

**Fix a typo in the message:**
```bash
git commit --amend -m "corrected message"
```

**Forgot to include a file:**
```bash
git add forgotten_file.py
git commit --amend
```
This merges the forgotten file into the same commit as before, instead of creating a new one.

**How it actually works:** `--amend` doesn't edit the old commit in place — it creates a **new commit that replaces the old one** (new hash, old one no longer part of the branch). Git makes it look like a clean rewrite instead of having two messy commits.

**Warning:** only amend commits that are still local/unpushed. If a commit was already pushed and a teammate pulled it, amending it and force-pushing later can silently overwrite anything they added on top — see scenario below.

### `--allow-empty` — why it's useful

Normally git refuses to commit if nothing changed. This flag overrides that. Used for:
- Triggering CI/CD pipelines without changing any code (e.g. testing if a pipeline works, or forcing a redeploy)
- Marking a bookmark in history (e.g. "Sprint 1 ends here") without touching files
- Quickly generating commit history to practice git commands on

### `-v` — why it's useful

Opens the editor to write the message, but also shows the actual diff (exact changed lines) right there as reference — helps write an accurate message without relying on memory of what changed. Doesn't affect what gets committed, purely a convenience.

### `-S` — GPG signing

Proves a commit genuinely came from me, not just someone typing my name/email into their own config. Requires a one-time GPG key setup, then the public key is added to GitHub — GitHub shows a "Verified" badge on signed commits. Mostly relevant for open-source/team projects, not needed for personal projects.

### `--fixup` — marking a fix for an earlier commit

```bash
git commit --fixup <commit>
```

Instead of a normal new commit for a small fix to an earlier commit, this marks it as a fix for that specific commit. Git auto-generates the message (`fixup! <original message>`) — no custom message needed, since `--autosquash` later matches on this exact format.

**Example:**
- A - "add login function"
- B - "add signup page"

Fix A's bug:
```bash
git add login.py
git commit --fixup A
```
Creates commit `D - "fixup! add login function"` at the end of history.

Later, clean it up:
```bash
git rebase -i --autosquash A
```
Git finds D, moves it right after A, and squashes it in. Final history: A now includes the fix, D no longer exists separately. Pairs with interactive rebase.
