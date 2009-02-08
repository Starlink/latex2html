# babel.perl
#
# written by Marek Rouchal <marek@saftsack.fs.uni-bayreuth.de>
# Last modification: Sun Oct 27 20:34:56 MET 1996
#
# This file is in alpha stage development
# currently it serves only as a wrapper for german.perl

package main;

# for debugging only
# print "Using babel.perl\n";

# implement usable options from LaTeX

sub load_babel_file {
    local($lang) = @_;
    local($dir) = '';
    print "\nbabel.perl: Loading $lang.perl\n" if $DEBUG;
    foreach $dir (split(/:/,$LATEX2HTMLSTYLES)) {
	if (-f "$dir$dd$lang.perl") {
           require("$dir$dd$lang.perl");
	}
    }    
}

#sub do_babel_german {
#    local($file,$dir)=("german.perl",'');
#    print "\nbabel.perl: Loading german.perl\n" if $DEBUG;
#    foreach $dir (split(/:/,$LATEX2HTMLSTYLES)) {
#	if (-f "$dir$dd$file") {
#           require("$dir$dd$file");
#	}
#    }
#}

sub do_babel_german { &load_babel_file("german") }
sub do_babel_austrian { &load_babel_file("german") }
sub do_babel_french { &load_babel_file("french") }
sub do_babel_francais { &load_babel_file("francais") }

# cancel redundant options from LaTeX

# none so far

1;	# Must be last line
