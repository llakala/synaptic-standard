TODO REWRITE

But, of course, we encounter a new problem: what if these files start getting
too big on their own?

Let's use an example. I have a ton of Git configuration: abbreviations, aliases,
settings, and some external tools. Altogether, this comes out to 198
significant lines of code. Not horrible - but definitely more than I can fit
on my screen.

I could store all of this in a `git.nix` file, and search within it whenever I
want to change something. But that's just returning to the problems we found
with a single `configuration.nix`. Instead, what if we store the different parts
of the git config within a `git/` folder? Now, we can have different files for
each PART of configuring git.

```bash
git/
├── abbrs.nix
├── aliases.nix
├── diff-so-fancy.nix
├── difftastic.nix
├── git.nix
├── revise.nix
└── settings.nix
```

Each of these files are small and maintainable, and it's easy to find a specific
part of your config without searching. But how do we handle auto-imports when we
now have nested folders?

Well, we make our import function recursive! If it finds a folder, it should
grab all the nix files within it. We can now extend our filetree with new files
AND folders whenever we choose.

