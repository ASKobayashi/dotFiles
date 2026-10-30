function pgpimport --description 'Import a PGP key from clipboard'
    # Usage: copy someone's public key block (e.g. a researcher's), then
    # `pgpimport` to add it to your keyring so you can encrypt to them.
    pbpaste | gpg --import
end
