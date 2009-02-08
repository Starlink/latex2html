# color.perl by Michel Goossens <goossens@cern.ch>  01-14-96
#
# Extension to LaTeX2HTML V 96.1 to support color.sty
# which is part of standard LaTeX2e graphics bunble.
#
# Change Log:
# ===========

package main;

# Get rid of color specifications, but keep contents

&ignore_commands( <<_IGNORED_CMDS_);
color # [] # {}
textcolor # [] # {}
pagecolor # {}
definecolor # {} # {} # {}
colorbox # {}
fcolorbox # {} # {}
_IGNORED_CMDS_

1;	# Must be last line
