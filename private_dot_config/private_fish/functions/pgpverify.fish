function pgpverify --description 'Verify a PGP signature from clipboard'
    # Usage: copy the signed block, then `pgpverify` to check the signature
    # without printing the body. (Use `pgpdec` to also see the signed text.)
    pbpaste | gpg --verify
end
