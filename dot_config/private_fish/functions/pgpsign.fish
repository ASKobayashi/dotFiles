function pgpsign --description 'PGP clear-sign clipboard → clipboard'
    # Usage: compose in Gmail, copy, `pgpsign`, paste back. Recipient can read
    # it as-is and verify it came from you. Prompts for your key passphrase.
    set -l tmp (mktemp)
    pbpaste | gpg --clearsign >$tmp
    set -l st $pipestatus[2]
    if test $st -eq 0
        pbcopy <$tmp
        echo "pgpsign: signed to clipboard" >&2
    else
        echo "pgpsign: signing failed (clipboard unchanged)" >&2
    end
    rm -f $tmp
    return $st
end
