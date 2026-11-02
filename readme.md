# Infinidoge's Universe

### An Essay on the Overengineering of Dotfiles

## Notes

This repository is not a general purpose configuration.
It is tailored specifically to our uses, and while you may find inspiration from it, do not expect it to be your productivity silver bullet.
Additionally, WE WILL FORCE PUSH TO THIS REPOSITORY WITHOUT NOTICE.

## History

In the beginning, there was Digga and DevOS.
Back when we were in high school, we took part of our schedule to work on a personal project, and decided to create a new NixOS configuration.
We found DevOS[^DevOS used to be in a separate repo, but has since been merged into an example for Digga.], and accordingly, [Digga](https://github.com/divnix/digga).
It is with DevOS that we first began building our NixOS configuration.
We cut out the parts we didn't want, and got to work.
The initial configuration was messy and hard to expand, but it worked.

Today, Digga is deprecated, and it hasn't seen updates in years.
In its stead, other libraries showed up.
Since then, while we still keep some digga things around (in [lib/digga.nix](lib/digga.nix)), we now use [flake parts](https://flake.parts/) to manage the root of our configuration.
Most modules are 'global' instead of excessively gated by enables.

However, times are changing.
We are getting frustrated with how things are so needlessly coupled, and tired of how things are a bit scattered.
So we are hoping to move towards a more [dendritic](https://dendrix.oeiuwq.com/Dendritic.html) model, to decouple parts of our configuration.
We'll see if we follow the trend though, as sometimes we want to write libraries ourselves.
