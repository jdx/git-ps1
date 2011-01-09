#!/bin/bash
#
# git-ps1 - git-augmented PS1
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
# #

BRANCH=$(git symbolic-ref HEAD 2>/dev/null \
    || git rev-parse HEAD 2>/dev/null | cut -c1-10 \
)

# if no branch or hash was returned, then we're not in a repository
if [ -z "$BRANCH" ]; then
    exit
fi

BRANCH=${BRANCH#refs/heads/}
GIT_STATUS=$( git status 2>/dev/null )

STATUS=''
COLOR="\[\033[00;33m\]"

# uncommited files
if [ "$( echo $GIT_STATUS | grep 'Changed\|uncommitted' )" ]; then
    STATUS="$STATUS*"
fi

# not on branch/behind origin
if [ "$( echo $GIT_STATUS | grep 'Not currently on\|is behind' )" ]; then
    COLOR="\[\033[0;31m\]"
fi

# staged
if [ "$( echo $GIT_STATUS | grep 'to be committed' )" ]; then
    STATUS="$STATUS\[\033[0;32m\]*"
fi

# untracked
if [ "$( echo $GIT_STATUS | grep 'Untracked' )" ]; then
    STATUS="$STATUS\[\033[0;31m\]*"
fi

if [ "$( echo $GIT_STATUS | grep 'is ahead' )" ]; then
    AHEAD_COUNT=$( echo $GIT_STATUS | grep -o 'by [0-9]\+ commits\?' | cut -d' ' -f2 )
    STATUS="$STATUS$COLOR@$AHEAD_COUNT"
fi

# output the status string
echo " $COLOR[$BRANCH$STATUS$COLOR]"
