# pass-create

An extension for [pass](https://www.passwordstore.org/) (the standard Unix password manager)

It allows a easy passwod creation with metadata via a dialog.

## Usage

```
Usage:
$PROGRAM create [opts]
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
```