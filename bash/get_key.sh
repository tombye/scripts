#! /bin/bash

usage {
  cat << EOF
  Usage: $0 <path-to-key>
  
  Show fingerprint of specified public key file

EOF
}

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

ssh-keygen -l -f $1
