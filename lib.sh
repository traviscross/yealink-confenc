###### -*- mode:sh -*-

# Yealink's encryption tool generates a "random" key using characters
# [a-zA-Z0-9].  It uses this key directly as a stream of bytes to
# encrypt the configuration file with AES-128-ECB.  Then it encrypts
# this key with a "common" key distributed as part of the firmware and
# the encryption tool and writes the result to a second file, also
# using AES-128-ECB.

encrypt_key () {
  local key="$1"
  printf "$key" | openssl enc -aes-128-ecb -nopad \
    -K $(printf 'EKs35XacP6eybA25' | xxd -p)
}

decrypt_key () {
  local keyfile="$1"
  openssl enc -aes-128-ecb -d -nopad -in $keyfile \
    -K $(printf 'EKs35XacP6eybA25' | xxd -p)
}

encrypt_cfg () {
  local cfg="$1" key="$2"
  openssl enc -aes-128-ecb -nopad -in $cfg \
    -K $(printf "$key" | xxd -p)
}

decrypt_cfg () {
  local cfg="$1" key="$2"
  openssl enc -aes-128-ecb -d -nopad -in $cfg \
    -K $(printf "$key" | xxd -p)
}
