#!/bin/sh
export LANG=C
export LC_CTYPE=C
export LC_ALL=C
find . -not \( -name .svn -prune -o -name .git -prune \) -type f -print0 | xargs -0 sed -i '' -E "s/[[:space:]]*$//"
