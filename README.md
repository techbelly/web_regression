A simple tool to compare screenshots of webpages to make css refactoring easier
===============================================================================

Usage: web-regression [options] URL

    -r, --reference_png PNG_FILE     Png screenshot to compare against
    -f, --fastfail                   Fail as soon as a difference detected. Implies -n
    -n, --nodiff                     Don't create a diff png
    -o, --opendiff                   Open a png showing diffs highlighted with red border
    -h, --help                       Show this message
        --version                    Show version

Example:
    $ ruby -rubygems bin/web-regression -o http://www.example.org/index.html

Requires chunky_png and poltergeist and their respective dependencies.
