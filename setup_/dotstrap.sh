#!/usr/bin/env bash
# inspired by holdman's bootstrap


DOTFILES_ROOT="$HOME/opt/dotFiles"

set -e

show_help () { cat <<HELP
usage: $(basename "$0") --auto|osx|linux|fish|bash|help [--trial]

  --auto            Automagically install a new system

  --osx             Install a new OSX system

  --linux           Install a new linux system

  --link            Link all dotfiles

  --fish            Link dotfiles for Fish and Bash only

  --bash            Link dotfiles for Bash only

  --help | -h       Woh, meta...

  --trial           Optional. Dry-run links

HELP
exit;
}


info () {
    printf "\r\033[00;34mi\033[0m: $1\n"
}

user () {
    printf "\r\033[0;35m?\033[0m: $1 \n?:"
}

success () {
    printf "\r\033[00;32m+\033[0m: $1\n"
}

fail () {
    printf "\r\033[00;31m!\033[0m: $1\n"
    echo
    exit
}

grue () {
    printf "\033[00;31mYou were eaten by a grue.\033[0m\n"
    exit
}

link_files () {
    if [ "$trial" == "true" ]; then
        success "Pretend-Linked $1 to $2"
    else
        ln -s "$1" "$2"
        success "Linked $1 to $2"
    fi
}



install_dotfiles () {
    case "$system" in
        osx )
            files=$(find "$DOTFILES_ROOT" -maxdepth 1 -print);;
        linux )
            files=$(find "$DOTFILES_ROOT" -maxdepth 1 -print);;
        bash )
            files=$(find "$DOTFILES_ROOT" -maxdepth 1 -name "*bash*" -print);;
        fish )
            files=$(find "$DOTFILES_ROOT" -maxdepth 1 \( -name "*bash*" -o -name "*fish*" \) -print);;
        none )
            files=$(find "$DOTFILES_ROOT" -maxdepth 1 -print);;
        * )
            fail "I see that you're trying to install '$system' which makes no goddamn sense. Fix yo shit.";;
    esac

    linkfiles=$(echo "$files" | grep -vE '(\.git|\.md|\.DS_Store|_$|_\..$)')

    overwrite_all=false
    backup_all=false
    skip_all=false

    info 'Installing dotfiles...'
    for source in $linkfiles; do
        file_base=$(basename "${source}")

        if [[ ${dest:0:1} =~ [:upper:] ]]; then
            dest="$HOME/$file_base"
        else
            dest="$HOME/.$file_base"
        fi

        if [ -h "$dest" ] && [ $(readlink "$dest") = $source ]; then
            continue;
        fi

        if [ -f "$dest" ] || [ -d "$dest" ]; then

            overwrite=false
            backup=false
            skip=false

            if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ] && [ "$overwrite" == "false" ]; then
                user "$(basename "$dest") already exists.\n [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all, [g]ive up."
                read shellinput

                case "$shellinput" in
                    o )
                        overwrite=true;;
                    O )
                        overwrite_all=true;;
                    b )
                        backup=true;;
                    B )
                        backup_all=true;;
                    s )
                        skip=true;;
                    S )
                        skip_all=true;;
                    g|q )
                        grue;;
                    * )
                        continue;;
                esac
            fi

            if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]; then
                if [ "$trial" == "true" ]; then
                    success "Pretend-Removed $dest"
                else
                    rm -rf "$dest"
                    success "removed $dest"
                fi
            fi

            if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]; then
                if [ "$trial" == "true" ]; then
                    success "Pretend-Moved $dest to $dest.backup"
                else
                    mv "$dest" "$dest"\.backup
                    success "moved $dest to $dest.backup"
                fi
            fi

            if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]; then
                link_files "$source" "$dest"
            else
                success "skipped $source"
            fi

        else
            link_files "$source" "$dest"
        fi

    done

    info "Finished linking dotfiles"
    if [ "$system" == "bash" ] || [ "$system" == "fish" ]; then
        info "Restarting shell"
        exec "$(which $SHELL)" -l
    fi

}


install_osx () {
    if [[ $(xcode-select --version) ]]; then
        if [[ $(brew --version) ]] ; then
            info "Attempting to update Homebrew"
            brew update
        else
            info "Attempting to install Homebrew"
            ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
        fi
    else
        user "Can't find XCode CLI tools. Try to [i]nstall or [g]ive up"
        read shellinput
        case "$shellinput" in
            g|q )
                grue;;
            i|* )
                $(xcode-select --install)
                info "Try again when you get your shit together"
                exit;;
        esac
    fi
    system='osx'
    install_dotfiles
    "$DOTFILES_ROOT/setup_/osx.sh"
}

install_linux () {
    system='linux'
    install_dotfiles
    "$DOTFILES_ROOT/setup_/linux.sh"
}

check_environment () {
    if [[ $(uname -s) == "Darwin" ]]; then
        install_osx
    elif [[ $(uname -s) == "Linux" ]]; then
        install_linux
    else
        user "No idea what kind of system you're on.\n [o]sx, [l]inux, [b]ash only, [f]ish and bash, [g]ive up"
        read shellinput
        case "$shellinput" in
            o )
                install_osx;;
            l )
                install_linux;;
            b )
                system='bash'
                install_dotfiles;;
            f )
                systen='fish'
                install_dotfiles;;
            g|q|* )
                grue;;
        esac
    fi
}

case "$2" in
    "--trial" )
        info "Ima just pretend we're linkin stuff this time"
        trial="true";;
    "--auto"|"--osx"|"--linux"|"--link"|"--fish"|"--bash" )
        info "You can only specify one install type"
        show_help;;
    "--help"|"-h" )
        show_help;;
    *)
        continue;;
esac

case "$1" in
    "--auto" )
        check_environment;;
    "--osx" )
        install_osx;;
    "--linux" )
        install_linux;;
    "--link" )
        system='none'
        install_dotfiles;;
    "--fish" )
        system='fish'
        install_dotfiles;;
    "--bash" )
        system='bash'
        install_dotfiles;;
    "--help"|"-h" )
        show_help;;
    * )
        info "Unknown option: $1\n"
        show_help;;
esac

printf "\nDone!"
