#!/bin/sh
# Put homebrew openssl onto PATH so you stop using the ancient Apple openssl

set -eux

ln -sv /usr/local/opt/openssl/bin/openssl /usr/local/bin/
