# Problem

When you first install NixOS, it comes with a `configuration.nix` file. Even if
you move to flakes, you're still likely wrapping a normal `configuration.nix`.
Managing your entire desktop through a single file is really enticing to new NixOS
users. Coming from FHS distros, having a single source of truth for your system
sounds like a dream come true.

However, as your configuration grows, the downsides start to become clear.
Without a filesystem to enforce structure, a mega-file can quickly become
disorganized and difficult to maintain. This can lead to a bad relationship with
your code. Whenever you want to add something new, you end up increasing the
size of that file, and making your config even less maintainable.

# Solution

If our files are getting massive, we can make them smaller! If we turn what was
originally one big file into a few smaller components, our config can grow
horizontally. A few hundred lines is a lot, but when those lines are split
between 10 files, each one can stand on its own.

TODO TALK ABOUT SINGLE-PURPOSE FILES

However, splitting into files creates a new problem - lookups. No, not file
lookups - *mental* lookups. In a single file, you could just open the file and
Ctrl+F[^1] for where you wanted to go. But with a filetree, you're faced with a
question - which file am I actually trying to modify? Our friend here is
*semantic colocation*[^2].

How do we semantically colocate? Well, the core idea is simple - make your
filetree match the way *you* think about your code. To demonstrate this, I'm
going to show how three different people might structure their
config directory[^3].

TODO: use subheadings here

```sh
./alices-config
├── programs
│   ├── firefox.nix
│   ├── git.nix
│   └── packages.nix
└── system
    └── pipewire.nix
```
Alice clearly has a mental distinction between configuring a user-facing
program, compared to something more internal to her system. She thinks this is
the most intuitive way to sort your config.

```sh
./bobs-config
├── environment
│   └── systemPackages.nix
├── programs
│   ├── firefox.nix
│   └── git.nix
└── services
    └── pipewire.nix
```
Bob loves NixOS options. When he's thinking of a specific bit of config, he
thinks "oh, that's `programs.firefox`". He thinks this is the most intuitive way
to sort your config.

```sh
./craigs-config
├── browser.nix
├── packages.nix
├── sound.nix
└── vcs.nix
```
Craig doesn't think about the *program* - he thinks about what it's providing
him. He might change his browser, but `browser.nix` will persist, just like he
likes it. He thinks this is the most intuitive way to sort your config.

Every one of these filesystems have their own pros and cons. But Alice, Bob, and
Craig don't really care what the others think. What's important is that each
method of sorting is intuitive for the individual. That's what gives them those
fast mental lookups - where they immediately know where a file is stored,
because everything was placed purposefully.

# TLDR

Instead of keeping your config in one mega-file, split it into smaller files,
where each one has a singular purpose. Structure these files in the way that's
most intuitive for you - the goal should always be to have a gut sense of where
some piece of config is stored.

[^1]: (`/` for the Vim users)

[^2]: You'll be hearing that word a lot.

[^3]: Of course, you would have more files than this in practice - this just
lets us understand TODO.
