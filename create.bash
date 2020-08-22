#!/usr/bin/env bash

cmd_create_usage() {
    cat <<-_EOF
Usage:
    $PROGRAM create [opts] pass-name
        Creates a new password with metadata fields used e.g. in the browerpass addon.
        By default a new password is generated using pwgen unless -p us passed.
    $PROGRAM create help
        Prints this help message.
    $PROGRAM create -p
        Enter password manualy instead of generating one.

For installation place this bash script file "create.bash" into
the passwordstore extension directory specified with \$PASSWORD_STORE_EXTENSIONS_DIR.
By default this is ~/.password-store/.extensions.
E.g. cp create.bash ~/.password-store/.extensions
Give the file execution permissions:
E.g. chmod 700 ~/.password-store/.extensions/create.bash
Set the variable PASSWORD_STORE_ENABLE_EXTENSIONS to true to enable extensions.
E.g. export PASSWORD_STORE_ENABLE_EXTENSIONS=true
Type "pass create" to create a new entry.
E.g. pass create
_EOF
  exit 0
}

cmd_create_entry() {
    custom_password=0
    for i in "$@"
        do
        case $i in
            -p)
            custom_password=1
            shift
            ;;
            help | --help | -h)
            cmd_create_usage "$@"
            exit
            ;;
            *)
                # unknown option
            ;;
        esac
    done

    name=$1
    if [ -z "$name" ]; then
        echo "Name cannot be empty!";
        exit 1
    fi

    password=""
    if [ $custom_password -eq 1 ]; then
        read -p "Enter a password: " password
        if [ -z "$password" ]; then
            echo "Password cannot be empty!"
            exit 1
        fi

        read -p "Confirm password: " password2
        if [ "$password" != "$password2" ]; then
            echo "Passwords dont match!"
            exit 1;
        fi

    else
        password=$(pwgen --capitalize --numerals --symbols --secure --ambiguous 30 1)
    fi
    content="$content$password\n"
    
    read -p "Enter username: " username
    [ ! -z  "$username" ] && content="${content}username: $username\n"

    read -p "Enter URL: " url
    [ ! -z  "$url" ] && content="${content}url: $url\n"

    read -p "Enter OpenID URL : " openid
    [ ! -z  "$openid" ] && content="${content}openid: $openid\n"

    read -p "Add more data? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        text=""

        echo "Enter multiple lines add two empty lines to end: "
        while read line
        do
            # break if the line is empty
            [ -z "$line" ] && break
            text="$text$line\n"
        done
        [ ! -z  "$text" ] && content="${content}$text"
    fi

    
    echo -e "$content" | pass insert -m $name
    if [ $? -ne 0 ]; then
        exit 1;
    fi
    echo
    echo "Created entry $name with password: $password"
}

case "$1" in
help | --help | -h)
  shift
  cmd_create_usage "$@"
  ;;
*) cmd_create_entry "$@" ;;
esac
exit 0
