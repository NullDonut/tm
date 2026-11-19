## JTask

- A task and issue manager 
- Contains tags 
- Fast cli tool
- Made in Jai

### Idea and description
A minimal, local project filesystem oriented task manager with permanent short identifiers,simple file based storage and a developer friendly cli.

### Basic Ideation

- Each project its own local tasks/ folder with its individual tasks file with name hexadecimal hash like names.
- tasks/ 
  -> a34t3e/main.md
  -> b3saev/main.md

  All other files are ignored or act description for user.

  For now md file will only contain the task until I create a markdown parser.

### Points 

--> Points about id
- IDs permanent,unique and 8-12 hexadecimal.
- Task content might change but not ids.
- Collision detection everytime
- IDs case insensitive for cli user.
- Usage:
        ```bash
        tm edit a7345a1
        tm edit @2 //Temporary numerical index changed after a fs rewrite
        tm edit a77 //Also accepted as a prefix matching.
        ```

- For now dynamic array later on hashing for ID -> task index connction.

### For more info on semantics refer semantics.md that i wrote for this proj
