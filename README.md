# JTask

- A project-specific task and issue manager with a file structure storage system made in Jai.
- Fast cli tool
- Made in Jai

## Idea and description
A minimal, local project filesystem oriented task manager with permanent short identifiers,simple file based storage and a developer friendly cli.

## Basic Ideation

- Each project its own local tasks/ folder with its individual tasks file with name hexadecimal hash like names.
- tasks/ 
  -> a34t3e/main.md
  -> b3saev/main.md
--> Points about id
- IDs permanent,unique and 8-12 hexadecimal.
- Task content might change but not ids.

## Usage
```bash
tm edit a7345a1
tm edit a77 //Also accepted as a prefix matching.
tm edit a //If multiple commits are present will show choice.
```

## Installation
Download the binary for your system from the releases page and give it executable permissions.
```bash
chmod +x tm-v0.0.1-linux-x64
./tm-v0.0.1-linux-x64 //In your project directory
```

## Extra References

### For more info on semantics and working refer [semantics.md](https://github.com/NullDonut/tm/blob/main/semantics.md) that i wrote for this proj
### Image gallery [image-gallery.md](https://github.com/NullDonut/tm/blob/main/image-gallery.md)
### For a bit of devlog and backgroud read [background.md](https://github.com/NullDonut/tm/blob/main/background.md)
