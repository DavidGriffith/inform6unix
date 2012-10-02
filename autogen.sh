# Run this to set up the package for configuring.

run()
{
    echo "Running '$@'"
    eval "$@"
}

echo
run cp config/Makefile.am.lib lib/Makefile.am
run aclocal && run automake -a -c -f && run autoconf || exit 1
echo
echo Now run \'./configure\'
