# Run this to set up the package for configuring.

run()
{
    echo "Running '$@'"
    eval "$@"
}

echo
run aclocal && run automake -a -c -f && run autoconf || exit 1
echo
echo Now run \'./configure\'
