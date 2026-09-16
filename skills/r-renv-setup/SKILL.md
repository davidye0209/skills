---
name: r-renv-setup
description: >-
  Procedure for setting up isolated R virtual environments using renv with external library paths
  outside cloud-synced folders (e.g., Google Drive, Dropbox, OneDrive). Use whenever creating,
  initializing, or configuring an R project environment.
---

# R Project Environment Setup with `renv` (External Library)

This skill provides the standard runbook for initializing an isolated R package environment using `renv`, ensuring all heavy package binaries and caches are stored outside cloud-synced folders (e.g., Google Drive, Dropbox, OneDrive) while keeping lightweight project metadata (`renv.lock`, `.Renviron`, `.Rprofile`) tracked within the project repository.

---

## Why External Library Root?

Cloud sync engines struggle with R package libraries (thousands of small binary files, frequent lock contention, and high I/O latency). Storing the library in `~/.renv/library/` eliminates syncing lag while keeping the project 100% reproducible.

---

## Step-by-Step Initialization Procedure

### Step 1: Configure `.Renviron`
Before running `renv::init()`, create or append to `.Renviron` in the project root:

```bash
echo 'RENV_PATHS_LIBRARY_ROOT = ~/.renv/library' >> .Renviron
```

> **Optional:** If a non-hashed directory name is preferred instead of `<project>-<hash>`, also add:
> ```bash
> echo 'RENV_PATHS_LIBRARY_ROOT_ASIS = TRUE' >> .Renviron
> ```

### Step 2: Initialize `renv`
Run `renv::init` in bare mode (or standard mode if scanning existing code for dependencies):

```bash
Rscript -e "renv::init(bare = TRUE)"
```

This creates:
* `.Rprofile` (auto-sources `renv/activate.R` on R session start)
* `renv/activate.R` & `renv/settings.json` (bootstrap scripts)
* `renv.lock` (lockfile recording exact package versions)

### Step 3: Verify Library Path
Verify that R's active `.libPaths()` points to the external directory:

```bash
Rscript -e "cat('Active library paths:\n'); print(.libPaths())"
```

Expected output should show `~/.renv/library/<project-identifier>/...` as the primary library path.

---

## Routine Workflows & Commands

| Task | Command |
| :--- | :--- |
| **Install Package** | `Rscript -e "renv::install('<pkg>')"` |
| **Update Lockfile** | `Rscript -e "renv::snapshot(prompt = FALSE)"` |
| **Restore Environment** | `Rscript -e "renv::restore(prompt = FALSE)"` |
| **Check Sync Status** | `Rscript -e "renv::status()"` |

---

## VCS / Git Recommendations

Ensure `.gitignore` contains standard R entries:
```gitignore
.Rhistory
.RData
.Ruserdata
```
Do **not** gitignore `renv.lock`, `.Rprofile`, `.Renviron`, or `renv/activate.R`.
