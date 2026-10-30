function pgpenc --description 'PGP-encrypt clipboard to recipient(s), armored → clipboard'
    # Usage: compose in Gmail, copy the text, then `pgpenc them@example.com`,
    # then paste back over your draft. Add more recipients as extra args.
    # (Encrypt-only. To also sign: `pgpsign` first, or use gpg --sign --encrypt.)
    if test (count $argv) -eq 0
        echo "usage: pgpenc RECIPIENT [RECIPIENT...]" >&2
        return 2
    end
    set -l rcpt
    for r in $argv
        set -a rcpt --recipient $r
    end
    set -l tmp (mktemp)
    pbpaste | gpg --armor --encrypt $rcpt >$tmp
    set -l st $pipestatus[2]
    if test $st -eq 0
        pbcopy <$tmp
        echo "pgpenc: encrypted to clipboard — "(count $argv)" recipient(s)" >&2
    else
        echo "pgpenc: encryption failed (clipboard unchanged)" >&2
    end
    rm -f $tmp
    return $st
end
