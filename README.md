# What is this?

This repo aims to declare the patterns of the Synaptic Standard, an alternative
to the Dendritic Pattern. The Synaptic Standard aims to solve many of the same
problems as the Dendritic Pattern, but without a ton of boilerplate, or a
reliance on `flake-parts`.

# What does the dendritic pattern get right?

The reason I'm writing this is because I think the dendritic pattern gets all
the PROBLEMS right - it just solves them in the wrong ways. So, I want to start
by going through some axioms. Once we learn about the issues with the classical
ways of structuring your files in NixOS, we can go through:

- The solutions the dendritic pattern uses
- Why I think those solutions miss the mark
- The solutions I use instead to solve the same issues


## A single configuration.nix is hard to maintain. When you first install NixOS,
it comes with a `configuration.nix` file. Even if you move to flakes, you're
likely still wrapping a normal `configuration.nix`. This file gets increasingly
hard to maintain, as the amount of configuration you have increases over time.

The solution to this is to split your `configuration.nix` into multiple files.
And splitting is great. Want to add some configuration for `fish`? Make a
`fish.nix` file. How about `gnome`? Make a `gnome.nix` file!

This is our first foray into the principle that guides all of this: **semantic
collation**. The idea is that the name of a file and its location in your
filetree should be intuitive. More on this later - but keep this in the back of
your mind. This is really what we're shooting for.

## Manual importing sucks

Okay, so now we make new files all the time. But there's a problem: every time
you make a new file, you have to `import` it to your configuration. And if you
FORGET to import the file, you have a very frustrating bug on your hands, where
you're making changes and rebuilding, but nothing seems to be applying.

We found the dawback of splitting: you end up babysitting your imports all the
time. How do we keep the semantic colocation from splitting, while not having to
constantly update our `default.nix`? I believe the solution to this is a good
auto-import function. Now, you can make new files as often as you want.

## Auto-imports shouldn't just be flat

But, of course, we encounter a new problem: what if some of these files start
getting too big on their own?

Let's use an example. I have a ton of git configurations: abbreviations,
aliases, settings, and configuration of a few external git tools:
`diff-so-fancy`, `difftastic`, and `git-revise`. Altogether, this comes out to
198 lines of significant lines of code. Not horrible - but definitely more than
I can fit on my screen.

I could store all of this in a `git.nix` file, enter the file, and search for
whatever I want to change. But that's just bringing back the problems we found
with a single `configuration.nix`. Instead, what if we store the different parts
of my git config within a `git/` folder? Now, we can have different files for
each PART of configuring git.

```bash
❯ tree ./git/
./git/
├── abbrs.nix
├── aliases.nix
├── diff-so-fancy.nix
├── difftastic.nix
├── git.nix
├── revise.nix
└── settings.nix
```

Each of this files are small and maintainable, and it's easy to find a specific
part of your config. But how do we handle auto-imports when we now have nested
folders?

Well, we make our import function recursive! If it finds a folder, it should
grab all the nix files within it. Now, we can extend our filetree with new files
AND folders, and the auto-import function will automatically adapt.

WIP, KEEP WRITING
