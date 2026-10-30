function pgpdec --description 'Decrypt/verify a PGP block from clipboard → terminal'
    # Usage: select the PGP block in the email, copy it, then `pgpdec`.
    # Handles encrypted, encrypted+signed, and clear-signed messages; prints
    # the plaintext to the terminal (never to disk or the clipboard) and shows
    # the signature status on stderr.
    pbpaste | gpg --decrypt
end
