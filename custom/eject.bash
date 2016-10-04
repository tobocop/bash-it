function eject { command hdiutil eject `df | grep Volumes | grep -i "$@" | ruby -ne 'puts $_[/^[^ ]*/]'`; }
