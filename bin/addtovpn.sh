#!/usr/bin/env bash

name=$1
number=$2
address="192.168.200.$number/32"

private=$(wg genkey)
public=$(echo "$private" | wg pubkey)
psk=$(wg genpsk)

cat << EOF > /tmp/$name.conf
[Interface]
Address = $address
PrivateKey = $private
DNS = 1.1.1.1

[Peer]
PublicKey = $(cat /etc/secrets/wireguard/public)
PresharedKey = $psk
Endpoint = vpn.inx.moe:51820
AllowedIPs = 0.0.0.0/0
EOF

cat << EOF >> /tmp/wireguard-config.nix
{
  name = "$name";
  publicKey = "$public";
  presharedKey = "$psk";
  allowedIPs = ip $number;
}
EOF
