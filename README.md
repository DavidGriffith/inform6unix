**Welcome to Inform!**
=======================

---

Inform is an Interactive Fiction (text adventure) game compiler -- it takes
source code you write and turns it into a game data file which is then
played using an *interpreter*.  There are several interpreters available
which can play Inform games on different machines (e.g. frotz, jzip) -- you
can probably obtain one from the same place you got this package.

Inform was originally written by Graham Nelson, and you are free to
redistribute it under certain conditions -- see the file COPYING for
details.

What's in this distribution?
----------------------------

The following subdirectories are included in the package:

- ***src***	--- source code for the Inform program
- ***lib***	--- Inform library files
- ***include***	--- selection of useful include files
- ***demos***	--- some Inform demo games (including the classic *advent*)
- ***tutor***	--- some Inform tutorial files
- ***docs***	--- internal Inform documentation and release notes
- ***contrib***	--- other contributed Inform stuff

How do I install it?
--------------------

If you're working from the Github repository 
https://github.com/DavidGriffith/inform6unix, do this first:

    make submodules

Then, here's how to build Inform6:

    make
    make install

This will install the following (assuming default installation):

    Inform executable in /usr/local/bin
    Inform library files in /usr/local/share/inform/lib
    Inform include files in /usr/local/share/inform/include
    Inform tutorial games in /usr/local/share/inform/tutor
    Inform demo games in /usr/local/share/inform/demos

If you want to install Inform somewhere other than /usr/local, edit 
Makefile accordingly.

OK, it's installed.  Now what?
------------------------------

There are three canonical works documenting the Inform6 language.  These 
are the Inform Designers Manual (4th ed), the Inform Beginner's Guide, 
and the IF Theory Reader.  These are at 
http://inform-fiction.org/manual/index.html.  At least the the Inform 
Designer's Manual is currently available on Amazon as a hardcopy 
hardcover book.  Once you get a feel for the language, you can go 
through the demos/ and docs/ directories and follow along with the 
books. After that, you're all set to write an IF game!  Yay!

Troubleshooting
---------------

If you have any problems with anything, contact the relevant person
listed in the AUTHORS file.  If you're not sure who that is, contact me
instead, at the address at the end of this file.

The Interactive Fiction archive
-------------------------------

There's a good chance that you got this package from the IF archive, or one
of its mirrors.  But if you didn't, you might like to check it out
http://www.ifarchive.org

It has lots of great things: games, hints, solutions, authoring systems
(like this one), programs for playing the games, tools for making maps, and
stuff about the late, great Infocom.

There are also more resources for programming with Inform, including a
version of the Inform Designer's Manual suitable for printing.  See the
stuff in the programming/inform6 subdirectory.

The Inform maintainers
----------------------

An active community of Inform maintainers exists to fix bugs, implement new
features and issue new versions of the program.  If you'd like to know
more, or you think you've found a bug, visit them at 
http://inform7.com/contribute/report/

About this package
------------------

This package was originally created by Glenn Hutchings to address the
tedium of gathering the program, libraries, and documentation for
several different Unix machines.  It received blessing from Graham
Nelson.  The result is a package that automates the configuration and
installation process.  It should build and install on all Unix, Linux,
and Win32/Cygwin system.

This package is an ideal base for creating pre-compiled packages in the
style of Debian .debs, Redhat .rpms and similar schemes as well as build
trees like FreeBSD ports, NetBSD pkgsrc, and Gentoo portage.

Many people contributed to the contents of this package.  See the file
AUTHORS for more details.

This package is hosted at Github:

https://github.com/DavidGriffith/inform6unix

Feel free to hack on it and send me improvements!

Finally...
----------

If you have any comments or suggestions (or anything else, for that matter)
feel free to drop me a line.  I am:

David Griffith <dave@661.org>.
