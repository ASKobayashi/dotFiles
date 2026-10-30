function pgpkey --description 'Export your PGP public key → clipboard (+ stdout)'
    # Usage: `pgpkey you@example.com` copies your public key block to the
    # clipboard (and prints it) so you can share/publish it. With no argument,
    # exports every public key in your keyring.
    set -l tmp (mktemp)
    gpg --armor --export $argv >$tmp
    set -l st $status
    if test $st -eq 0 -a -s $tmp
        pbcopy <$tmp
        cat $tmp
        echo "pgpkey: public key copied to clipboard" >&2
    else
        echo "pgpkey: no matching key / export failed" >&2
        set st 1
    end
    rm -f $tmp
    return $st
end
