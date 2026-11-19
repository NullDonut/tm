### JTask — Preliminary Blueprint

Goal: A minimal, filesystem-based task manager written in Jai.

### 1\. Storage

```text
project/
└── .jtask/
    └── tasks/
        ├── a7f2c9b1
        ├── b912e4a2
        └── c831d7f4
```

* One file per task.

* Filename is a randomly generated, permanent ID.

* File content is just the task title.

* No timestamps or extra metadata for now.

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

* Find `.jtask` in the current directory or parent directories.

* Store tasks inside `.jtask/tasks/`.

* No global task storage in v1.

### 6\. Development order

* Project and directory handling.

* ID generation and task creation.

* Loading and listing tasks.

* Show, edit and remove.

* Prefix and index resolution.

* CLI polish and error handling.

### 7\. Out of scope for v1

No tags, priorities, descriptions, statuses, due dates, databases, sync or TUI.

Core principle: Keep each task as a normal file. JTask should manage those files, not hide them behind a complicated storage system.
