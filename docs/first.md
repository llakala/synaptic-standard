# Introduction

This page aims to go over the common issues encountered when creating and
maintaining a NixOS configuration. This will provide us with a strong foundation
for understanding how these problems could potentially be solved.

## A single `configuration.nix` is hard to maintain

When you first install NixOS, it comes with a `configuration.nix` file. Even if
you move to flakes, you're still likely wrapping a normal `configuration.nix`.
This file gets increasingly hard to maintain as the amount of configuration you
have increases over time.

The solution to this is to split your `configuration.nix` into multiple files.
And splitting is great. Want to add some configuration for `fish`? Make a
`fish.nix` file. How about `gnome`? Make a `gnome.nix` file!

This is our first foray into the guiding principle behind everything: **semantic
collation**. The idea is that the name of a file and its location in your
filetree should be intuitive. More on this later - but keep it in the back of
your mind. This is really what we're shooting for.

## Manual importing sucks

Okay, so now we're making new files all the time. But there's a problem: every
time you make a new file, you have to `import` it to your configuration. And if
you FORGET to import the file, you have a frustrating bug on your hands, where
you're making changes and rebuilding, but nothing seems to be changing.

We found the drawback of splitting: you end up babysitting your imports. How do
we keep the semantic colocation we earned from splitting, while not having to
constantly manage our `default.nix`? I believe the solution to this is a good
auto-import function. Now, you can make new files as often as you want, and the
auto-importer will handle it for you.

## Auto-imports shouldn't just be flat

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
./git/
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

## Split trees are frustrating to search through

Take a filetree like this (simplified for example purposes):

```bash
├── home-manager/
│   ├── git.nix
│   └── zsh.nix
├── nixos/
│   └── zsh.nix
├── flake.lock
├── flake.nix
```

At this point, we've adopted `home-manager` into our config, and we're using it as
a NixOS module. The most common way of working with home-manager is to have a
separate directory for home-manager config, since it uses a separate module
system.

Sometimes, though, we need to use BOTH nixos and home-manager to accomplish
something. The NixOS module lets us enable `zsh` system-wide, and set it as our
default user shell. Meanwhile, the home-manager module provides a lot of options
for configuration, and is great for setting your opinionated zsh settings.

These kinds of splits create a frustrating user experience. Every time you want
to make a zsh change, you have to remember which module set to use. If only we
could have something like this:

```bash
├── modules/
│   └── zsh/
│       ├── home-manager.nix
│       └── nixos.nix
├── flake.lock
├── flake.nix
```

Or, even better:

```bash
├── modules/
│   └── zsh.nix
├── flake.lock
├── flake.nix
```

We've discovered one of the most important parts of a well-organized NixOS
configuration: **semantic colocation**. When we split between `nixos` and
`home-manager` configuration, we're splitting based on the implementation.
Instead, we prefer to split based on semantics. Even though our zsh config uses
multiple module sets, we prefer to store it as a single unit. This makes it easy
to navigate your filetree, since everything is organized intuitively.

Semantic colocation is the core idea behind the Synaptic Standard, and its
influences extend far beyond just combining nixos and home-manager config. If I
can leave you with one lesson, it's to think semantically when organizing your
filetree. Everything else can be derived from that base principle.

# What now?
Now, you're familiar with the problems that we aim to solve. To learn about how
the Synaptic Standard does this, please navigate to the [next
document](second.md).
