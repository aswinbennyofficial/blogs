---
title: "Git Internals Explained"
date: 2025-07-28
categories: [compile, internals]
tags: [git, version-control, programming, internals, development]
image: /assets/img/posts/git-internals-explained/1.png
description: >-
  Explore Git's internal architecture: objects, refs, and the .git directory. Learn how Git stores data and tracks changes under the hood.

# Additional SEO Tags
seo:
  type: Article
  date_modified: 2025-07-29
  links: ["https://blog.aswinbenny.in/posts/git-internals-explained/"]

# Git-specific keywords
keywords: ["git internals", "git objects", "git repository", "version control", "git architecture", "git blob", "git tree", "git commit", "git refs"]

# Social sharing optimization
og_image: /assets/img/posts/git-internals-explained/1.png
og_description: "Deep dive into Git's internal architecture: how Git stores and manages your code behind the scenes"

# Content metadata
breadcrumbs: true
toc: true
---



## 🗃️ Objects

Git uses three main types of objects to store and manage your code:
- Commit
- Tree
- Blobs

![Git Internals Overview](/assets/img/posts/git-internals-explained/2.png)
> Red: commit object, Blue: tree object, Grey: blob object

### 📄 Blobs (Binary Large Objects)

**What are blobs?**
- Store the actual contents of files
- Contain full snapshots, not just differences
- Identified by unique SHA-1 hash (20 bytes = 40 hexadecimal characters)

**Key characteristics:**
- **Content only**: Unlike regular files that have metadata (creation date, permissions), blobs store only raw file content
- **Immutable**: Once created, a blob's contents cannot be changed. Any modification creates a new blob with a different hash

### 🌳 Trees

**What are trees?**
- Represent filesystem structure or directory listings
- Reference other trees (subdirectories) or blobs (files) by their hashes
- Each tree has its own unique SHA-1 hash

**How they work:**
- Trees can contain other trees, representing nested directories
- They maintain the structure and organization of your project

![Tree Structure](/assets/img/posts/git-internals-explained/3.png)

### 📝 Commits

**What are commits?**
- Represent a complete snapshot of your repository at a specific point in time
- Combine metadata with a pointer to the root tree

**Commit contents:**
- **Committer information**: Author details
- **Timestamp**: When the commit was created
- **Commit message**: Description of changes
- **Parent pointers**: References to previous commits (merge commits have multiple parents)
- **Tree reference**: Points to the root tree object

![Commit Structure](/assets/img/posts/git-internals-explained/4.png)

**Important notes:**
- Commits store entire snapshots, not just diffs from previous commits
- Identified by SHA-1 hash (same as shown in `git log`)

**How changes propagate:**
- Updating a file creates a new blob with different hash
- This changes the tree hash that contains the file
- Which changes the commit hash that references the tree

![Hash Chain Effect](/assets/img/posts/git-internals-explained/5.png)

**Efficient storage:**
- Only modified files get new blobs
- Unchanged files are referenced, not duplicated
- New commits reference their parent commits

![Efficient Storage](/assets/img/posts/git-internals-explained/6.png)

**Hash uniqueness:**
Two different people creating identical files will have the same blob and tree hashes, but different commit hashes due to different author information and timestamps.


---

## 🌿 Branches

**What are branches?**
- Named references to specific commits
- Lightweight pointers that move as you create new commits

![Branch Structure](/assets/img/posts/git-internals-explained/7.png)

**How branches work:**
- **HEAD** defines your currently active branch
- `git checkout ` moves HEAD pointer to that branch
- Creating commits on non-master branches updates that branch's pointer

![Branch Commits](/assets/img/posts/git-internals-explained/8.png)

## 🔄 Changes and Workflow

**Repository structure:**
- **Repository**: Collection of commits
- **Working directory**: Your `.git` folder plus all project files
- **Staging area (index)**: Where changes are prepared before committing

![Git Workflow](/assets/img/posts/git-internals-explained/9.png)

**File states:**
- **Tracked**: Files present in previous commit or added to staging area
- **Untracked**: New files Git doesn't know about yet

Changes are registered in the `index` (staging area) using `git add`.

## 📁 .git Directory Structure

The `.git` directory contains everything Git needs:

```
.git/
├── HEAD (file)
├── index (file)
├── objects/
│   ├── 11/
│   │   └── 8f108d76b16a058db9fcb385a5fd640b54e47a
│   └── [other hash folders...]
└── refs/
    └── heads/
        └── master (file)
```

**Directory components:**
- **`objects/`**: Stores all Git objects (blobs, trees, commits)
  - Subdivided by first two characters of hash for efficiency
- **`refs/`**: Directory for references
  - **`heads/`**: Contains branch files with commit hashes they point to
  - **`master`**: File containing hash of latest commit on master branch
- **`HEAD`**: Points to current active branch
  - Contains content like `ref: refs/heads/master`
- **`index`**: Represents the staging area

## 🛠️ Git Commands

### Basic Object Inspection

```
# Get the type of object from hash
git cat-file -t 

# Get the content of object from hash
git cat-file -p 
```

### Working with Hashes

**Generate and store hashes:**
```
# Get hash of string
echo "git is awesome" | git hash-object --stdin

# Get hash and store as object in Git database
echo "git is awesome" | git hash-object --stdin -w
```

This creates a blob object stored as:
```
objects/
└── 11/
    └── 8f108d76b16a058db9fcb385a5fd640b54e47a
```

**Retrieve object information:**
```
# Get file type of hash
git cat-file -t 

# Get content of hash
git cat-file -p 

# Save hash content to file
git cat-file -p  > hello.txt
```

**Note**: A new blob is created when you add something to staging area using `git add`.

### Staging Operations

```
# Manually add blob to staging area
git update-index --add --cacheinfo 100644  
```

This creates the `index` file.

### Committing Process

```
# Create tree from current working directory
git write-tree
```

This returns the hash of the root tree, stored in the objects folder.

**Inspect the tree:**
```
# Check tree type and content
git cat-file -t 
git cat-file -p 
```

**Create commit:**
```
# Commit the tree
git commit-tree  -m "commit message" -p 
```

### Managing HEAD and Branches

**Update branch pointer:**
```
# Point master to latest commit
echo  > .git/refs/heads/master
```

**Branch operations:**
- **Create branch**: Add file in `.git/refs/heads/` containing commit hash
- **Switch branch**: Change HEAD file content to `ref: refs/heads/`

## 🗜️ Compression

Git optimizes storage using **zlib compression**:
- Combines LZ77 and Huffman coding algorithms
- Significantly reduces repository size
- Maintains data integrity while saving space

## 📚 References

- [Swimm - Git Internals Part 1](https://medium.com/swimm/a-visualized-intro-to-git-internals-objects-and-branches-68df85864037)
- [Swimm - Git Internals Part 2](https://medium.com/swimm/getting-hardcore-creating-a-repo-from-scratch-cc747edbb11c)

Understanding Git's internal architecture helps you work more effectively with version control and troubleshoot issues when they arise.
