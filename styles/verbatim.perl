#
# $Id$
# verbatim.perl
#   Jens Lippmann <lippmann@cdc.informatik.th-darmstadt.de> 17-DEC-96
#
# Extension to LaTeX2HTML to support the verbatim.sty LaTeX2e package.
#
# Change Log:
# ===========
#  jcl = Jens Lippmann <http://www-jb.cs.uni-sb.de/~www/people/lippmann>
#
# $Log$
# Revision 1.1  2004/02/20 13:13:28  nxg
# Initial import
#
# Revision 1.1  1998/08/20 16:03:46  pdraper
# *** empty log message ***
#
# Revision 1.3  1996/12/23 01:33:58  JCL
# uses now shell variable TEXINPUTS (this is set up by LaTeX2HTML before)
# to locate the input file
#
# Revision 1.2  1996/12/18 04:30:32  JCL
# was formerly verbatimfiles.perl, however, its face changed
# quite much
#
#
# Note:
# This module provides translation for the \verbatiminput command of
# the verbatim.sty package.
# The comment/verbatim environments are handled by LaTeX2HTML itself.
#
# The naming of verbatim.sty is a bit blurred.
# Here are the versions which are available, together with their
# identification:
#  o dbtex verbatim.sty by Rowley/Clark
#    Provides:
#    - \verbatimfile, \verbatimlisting
#    It is also named verbatimfiles.sty, and supported by
#    verbatimfiles.perl.
# 
#  o verbatim.sty 1.4a (jtex), 1.4d (ogfuda), 1.4i (AMS LaTeX),
#    1.5i (LaTeX2e) by Sch"opf
#    Provides:
#    - verbatim environment, comment environment, \verbatiminput
#    Supported by this Perl module.
# 
#  o FWEB verbatim.sty
#    Provides:
#    - verbatim environment, \verbfile, \listing, \sublisting
#    Currently not supported by LaTeX2HTML.

package main;

sub do_cmd_verbatiminput {
    local($outer) = @_;
    local($_);

    $outer =~ s/$next_pair_pr_rx//o;
    local($file) = $2;
    $file .= ".tex" unless $file =~ /\.tex$/;

    foreach $dir ("$texfilepath", split(/:/,$ENV{'TEXINPUTS'})) { 
	if (-f ($_ = "$dir/$file")) {
	    #overread $_ with file contents
	    &slurp_input($_);
	    last;
	}
    }
    # pre_process file contents
    &replace_html_special_chars;

    $verbatim{++$global{'verbatim_counter'}} = $_;
    join('',"<BR>\n",$verbatim_mark,'verbatim',$global{'verbatim_counter'},$outer);
}

1; 		# Must be last line
