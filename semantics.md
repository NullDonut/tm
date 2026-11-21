### JTask — Preliminary Blueprint

Goal: A minimal, filesystem-based md task manager written in Jai.

This is a task list that be used as a issue tracker,bug tracker and go along with your project (GIT).

### 1\. Storage

```text
project/
   └── tasks/
       ├── a7f2c9b1/TASK.md
       ├── b912e4a2/TASK.md
       └── c831d7f4
```

* One main task file per task and description and other supporting documents.

* Filename is a randomly generated, permanent ID (a-z and 0-9).

* Task file is just themd file md title. (TBD)
```
# Title

--- //End of parsed section content after will not be parsed and serve as user defined description.
<Description user defined>

```

* No timestamps or extra metadata for now. (For now)

* Detect ID collisions before creating files.

### 2\. Task identification

* Exact ID matching.

* Show matches when a prefix is ambiguous.

* IDs never change when titles are edited.

### 3\. CLI commands

```bash
jt add Fix compiler
jt list
jt show a7f2
jt edit a7f
jt remove a7f
jt help
```

(Not implemented TBD) `jt edit` opens the task using `$EDITOR`.

### 5\. Project discovery

* Find `tasks` in the current directory or parent directories.
* Store tasks inside `tasks/`.
* All tasks are stored in `task/hex-id/task.md`

### Future addition 
* A proper markdown parser for tags ,due dates and stuff.


No tags, priorities, descriptions, statuses, due dates, databases, sync or TUI.
All other files are ignored or act description for user.
For now md file will only contain the task until I create a markdown parser.


Core principle: Keep each task as a normal file. JTask should manage those files, not hide them behind a complicated storage system.
