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

* Task file is just themd file md title.
```
# Title

--- //End of parsed section content after will not be parsed and serve as user defined description.
<Descipription user defined>

```

* No timestamps or extra metadata for now. (For now)

* Detect ID collisions before creating files.

### 2\. Task identification

* Exact ID matching.

* Case-insensitive prefix matching.

* Show matches when a prefix is ambiguous.

* Optional temporary indexes, e.g. `@2`.

* IDs never change when titles are edited.

### 3\. CLI commands

```bash
jt add Fix compiler
jt list
jt show a7f2
jt edit a7f
jt remove a7f
jt paths
jt help
```

`jt edit` opens the task using `$EDITOR`.

### 4\. In-memory structure

```jai
Task :: struct {
    id: string;
    title: string;
}

tasks: [..]Task;
```

Start with a dynamic array. Add a hash map only if performance requires it.

### 5\. Project discovery

* Find `tasks` in the current directory or parent directories.

* Store tasks inside `tasks/`.

* No global task storage in v1.

### 6\. Development order

* Project and directory handling.

* ID generation and task creation.

* Loading and listing tasks.

* Show, edit and remove.

* Prefix and index resolution.

* CLI polish and error handling.


### Future addition 
* A proper markdown parser for tags ,due dates and stuff.

### 7\. Out of scope for v1

No tags, priorities, descriptions, statuses, due dates, databases, sync or TUI.

Core principle: Keep each task as a normal file. JTask should manage those files, not hide them behind a complicated storage system.
