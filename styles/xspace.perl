#
# $Id: xspace.perl,v 1.1 1997/01/27 19:40:44 JCL Exp $
# xspace.perl
#   Jens Lippmann <lippmann@cdc.informatik.th-darmstadt.de> 26-JAN-97
#
# Extension to LaTeX2HTML to support xspace.sty.
#
# Change Log:
# ===========
#  jcl = Jens Lippmann
#
# $Log: xspace.perl,v $
# Revision 1.1  1997/01/27 19:40:44  JCL
# initial revision
#
#
# JCL -- 26-JAN-97 -- created
#


package main;

sub do_cmd_xspace {
    local($_) = @_;
    local($space) = " ";
    # the list is taken from xspace.sty 1.04
    $space = "" if /^([{}~.!,:;?\/'\)-]|\\\/|\\ )/;
    $space.$_;
}

1; 		# Must be last line
