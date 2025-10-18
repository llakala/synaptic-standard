# Problem

By default, NixOS puts all your config within a single `configuration.nix`.
However, you may want to split that into multiple files, for reasons expressed
in [the previous standard](./1-small-semantic-files.md).

Let's make up a NixOS user named James. James used to have everything in a
`configuration.nix`, but as that's gotten unwieldy, he's been starting to
modularize his config. This is how his filetree currently looks:

```bash
./config
├── boot.nix
├── configuration.nix
├── git.nix
├── hardware-configuration.nix
└── nvim.nix
```

Of course, James has to actually import these files somehow. He could list all
the files directly in his `flake.nix`[^1] - but instead, he's doing it like
this:

```nix
  my-host = lib.nixosSystem {
    modules = [
      ./config
    ];
  };
```

This syntax might be unfamiliar to you. When Nix is given a reference to a
folder `foo`, it will resolve that path to `foo/default.nix`. This is just
syntax shorthand - writing `./config/default.nix` would give the same result.

Why is this useful? Well, it lets us split up our work. Rather than having every
single file listed in his `flake.nix`, James can just add a `default.nix` for
each folder, and let it handle direct file management. If James adds more
files/folders in the future, this will prevent his flake.nix from becoming an
unmaintainable mess.

Okay, but what's actually IN the default.nix that we're calling?

```nix
{
  imports = [
    ./boot.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./nvim.nix
  ];
}
```

TODO ADD TRANSITION

This looks all well and good! But when James rebuilds, his Git config doesn't
seem to be working. He tries enabling and disabling a few options, but nothing
changes. Take a second here - see if you can find the bug in the code.

Did you find it? `git.nix` is in the filetree, but it's missing from the
`imports` list. This is a problem that's unfortunately common. Nix has no way of
knowing what files you *wanted* to import, so if we ever forget,

# Solution

TODO

[^1]: Note that we'll use flake-centric examples for this document. That's
    simply because most readers are more familiar with flake-based
    APIs. However, all of these concepts extend to non-flake workflows too!
