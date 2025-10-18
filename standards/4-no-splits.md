# Problem

Take a filetree like this (simplified for example purposes):

```bash
├── home-manager/
│   ├── fzf.nix
│   ├── git.nix
│   └── scaling.nix
├── nixos/
│   ├── less.nix
│   └── scaling.nix
├── flake.lock
├── flake.nix
```

At this point, we've adopted `home-manager` into our config. The most common way
of working with home-manager is to have a separate directory for home-manager
config, since it uses a separate module system. This is what's known as
**implementation colocation**. We're storing our files based on what
implementation they are - nixos or home-manager.

But implementations are often arbitrary! Lots of programs can be managed
system-wide or as a specific user. If we're looking for a specific file, how are
we supposed to know which folder to check?

Well, we can GUESS. NixOS modules are typically older and under a higher degree
of scrutiny, while HM modules are better at handling newer and nicher programs.
But there are tons of exceptions. Here's a few:

- Git is an older program that FEELS like it would have a great NixOS module.
But the home-manager module has way more options, and is almost always used.
Why? Well, Git actually cares about the current user, so system-level stuff
doesn't make sense for it.
- TODO ADD MORE EXAMPLES

It gets worse. Sometimes, we need to use BOTH nixos and home-manager to
accomplish something. You might have noticed that we've got a `scaling.nix` in
both folders. Well, this is actually a real-life example from an old revision of
my config! My laptop has a weird screen resolution, and I needed to increase the
scaling to actually see anything. I could scale Gnome pretty easily through the
HM module:

```nix
# ./home-manager/scaling.nix
{
  dconf.settings."org/gnome/desktop/interface".scaling-factor = 2;
}
```

But when we boot up our system and enter gdm, we're not logged in yet, so it
instead runs under the `gdm` user. This means the `home-manager` config (which
is only defined for OUR user) doesn't apply. Luckily, the NixOS module
for `dconf` lets us apply settings per-user:

```nix
# ./nixos/scaling.nix
{ lib, ... }:

{
  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/interface".scaling-factor = lib.gvariant.mkUint32 2;
    }
  ];
}
```

But now our scaling logic is split between folders, even though we would ideally
have it together. This is another example of where implementation-based
structures fail - they don't match how we THINK about files. If I'm trying to
find some config, I don't care WHICH module set I used. I just want to find the
damn config. TODO WRAPUP SENTENCE

# Solution

TODO REWRITE

Did you know there's a better way?

```nix
# ./config/gnome/scaling.nix
{ lib, ... }:

{
  dconf.settings."org/gnome/desktop/interface".scaling-factor = 2;

  hm.programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/interface".scaling-factor = lib.gvariant.mkUint32 2;
    }
  ];
}
```

Notice the `hm` attribute. This is a custom **alias** we created, that lets us
access `home-manager` without a ton of subattrs. You can create it like this:

```nix
{ lib, inputs, ... }:

{
  imports = [
    # Import home-manager as a NixOS module
    inputs.home-manager.nixosModules.home-manager

    # alias to quickly access home-manager config through the `hm` attribute
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "MYUSERNAME")
  ];
}
```

Instead of having a split tree, we use a single `config` directory. Now, we
don't have to remember whether something is system-scoped or not - because it's
all integrated together.

Some quick notes before we move on:

1. This doesn't only apply to `home-manager`, although it's definitely the most
   common case of this happening.

2. This section could be interpreted as saying that you need to only have one
   folder for config. This isn't the intention. At the top level of my tree, I
   have an `apps` and a `config` folder. `apps` is where I put program-specific
   stuff, like `fish`. `config` is where I put more general stuff, like mimetype
   configuration. This is a split based on semantics, not implementation. We'll
   get more into this into the next section!
