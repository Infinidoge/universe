#!/usr/bin/env bash
# [[file:readme.org::bare_install][bare_install]]
# [[[[file:/etc/nixos/hosts/Infini-DESKTOP/readme.org::installing][installing]]][installing]]
echo "LOG: Installing NixOS"
sudo nixos-install --flake /etc/nixos#Infini-DESKTOP --no-root-password
# installing ends here
# bare_install ends here
