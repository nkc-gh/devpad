<h1 align="center">Version Control</h1>

<p><strong>1. What is Version Control</strong></p>

- Version Control is a system that tracks every change made to a file or a project over time — who changed it, what changed, and when.
- Instead of having one file that keeps getting overwritten, version control keeps a **full history of every change**, so you can go back to any previous state whenever you want.

**Example:** suppose I made 5 changes to a file, but now I want the version from change 2, not change 5. Version control lets me jump back to that exact point instantly, without losing changes 3-5 (they're still saved, I just switched what I'm looking at).

<p><strong>2. Why is it needed</strong></p>

- Without it, I'd end up with `file_final.py`, `file_final2.py`, `file_ACTUAL_final.py` — no real history, just guessing.
- If two people edit the same file, one person's work overwrites the other with no trace.
- If something breaks, there's no clean way to undo — just memory.
- Teams (5, 50, 500 people) work on the same project at once — everyone works on their own copy, changes get merged together, and if something breaks, it's clear exactly which change caused it and it can be reverted alone.

<p><strong>3. Git vs Hosting Platforms (GitHub / GitLab / Bitbucket)</strong></p>

- **Git** = the actual tool that tracks changes. Runs locally on my machine.
- **GitHub/GitLab/Bitbucket** = websites that store my git project online so it's backed up and others can access/collaborate on it.
- The tracking mechanism (git) is identical everywhere — platforms just add extra tools on top: code review, issue tracking, permissions, automated pipelines.

<br>

<h1 align="center"><strong>Folder Structure</strong></h1>

.
└── version_control  
&nbsp;&nbsp;&nbsp;&nbsp;├── [git_cmds.md](./git_cmds.md)  
&nbsp;&nbsp;&nbsp;&nbsp;└── [README.md](./README.md)