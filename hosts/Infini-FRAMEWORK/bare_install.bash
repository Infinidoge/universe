#!/usr/bin/env bash
# [[file:readme.org::bare_install][bare_install]]
# [[[[file:/etc/nixos/hosts/Infini-FRAMEWORK/readme.org::installing][installing]]][installing]]
echo "LOG: Installing NixOS"
sudo nixos-install --flake /etc/nixos#Infini-FRAMEWORK --no-root-password
# installing ends here
# bare_install ends here
