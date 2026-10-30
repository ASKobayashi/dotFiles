# PGP clipboard helpers (ported from fish functions). clipcopy/clippaste come
# from Oh My Zsh (see clipboard.zsh).
pgpenc() {
  # Usage: compose in Gmail, copy the text, then `pgpenc them@example.com`,
  # then paste back over your draft. Add more recipients as extra args.
  # (Encrypt-only. To also sign: `pgpsign` first, or use gpg --sign --encrypt.)
  if (( $# == 0 )); then
    echo "usage: pgpenc RECIPIENT [RECIPIENT...]" >&2
    return 2
  fi
  local tmp; tmp=$(mktemp)
  local -a rcpt; local r
  for r in "$@"; do rcpt+=(--recipient "$r"); done
  clippaste | gpg --armor --encrypt "${rcpt[@]}" > "$tmp"
  local st=$?
  if (( st == 0 )); then
    clipcopy < "$tmp"
    echo "pgpenc: encrypted to clipboard — $# recipient(s)" >&2
  else
    echo "pgpenc: encryption failed (clipboard unchanged)" >&2
  fi
  rm -f "$tmp"
  return $st
}

pgpdec() {
  # Usage: select the PGP block in the email, copy it, then `pgpdec`.
  # Handles encrypted, encrypted+signed, and clear-signed messages; prints
  # the plaintext to the terminal (never to disk or the clipboard) and shows
  # the signature status on stderr.
  clippaste | gpg --decrypt
}

pgpsign() {
  # Usage: compose in Gmail, copy it, `pgpsign`, paste back. Recipient can read
  # it as-is and verify it came from you. Prompts for your key passphrase.
  local tmp; tmp=$(mktemp)
  clippaste | gpg --clearsign > "$tmp"
  local st=$?
  if (( st == 0 )); then
    clipcopy < "$tmp"
    echo "pgpsign: signed to clipboard" >&2
  else
    echo "pgpsign: signing failed (clipboard unchanged)" >&2
  fi
  rm -f "$tmp"
  return $st
}

pgpverify() {
  # Usage: copy the signed block, then `pgpverify` to check the signature
  # without printing the body. (Use `pgpdec` to also see the signed text.)
  clippaste | gpg --verify
}

pgpkey() {
  # Usage: `pgpkey you@example.com` copies your public key block to the
  # clipboard (and prints it) so you can share/publish it. With no argument,
  # exports every public key in your keyring.
  local tmp; tmp=$(mktemp)
  gpg --armor --export "$@" > "$tmp"
  local st=$?
  if (( st == 0 && -s "$tmp" )); then
    clipcopy < "$tmp"
    command cat "$tmp"
    echo "pgpkey: public key copied to clipboard" >&2
  else
    echo "pgpkey: no matching key / export failed" >&2
    st=1
  fi
  rm -f "$tmp"
  return $st
}

pgpimport() {
  # Usage: copy someone's public key block (e.g. a researcher's), then
  # `pgpimport` to add it to your keyring so you can encrypt to them.
  clippaste | gpg --import
}
