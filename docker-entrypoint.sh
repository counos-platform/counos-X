#!/bin/bash

set -ex

if [ ! -e "$HOME/.counosx/counosx.conf" ]; then
    mkdir -p $HOME/.counosx

	echo "Creating bitcoin.conf"

	# Seed a random password for JSON RPC server
	cat <<EOF > $HOME/.bitcoin/bitcoin.conf
		disablewallet=${DISABLEWALLET:-1}
		printtoconsole=${PRINTTOCONSOLE:-1}
		rpcuser=${RPCUSER:-bitcoinrpc}
		rpcpassword=${RPCPASSWORD:-`dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64`}
EOF
fi

cat $HOME/.counosx/counosx.conf

echo "Initialization completed successfully"


if [ $# -gt 0 ]; then
    args=("$@")
else
    args=("-rpcallowip=::/0")

exec counos-x "${args[@]}"
