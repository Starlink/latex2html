# alltt.perl by Herbert Swan <dprhws.edp.Arco.com>  12-22-95
#
# Extension to LaTeX2HTML V 96.1 to supply support for the
# "alltt" standard LaTeX2e package.
#
# Change Log:
# ===========

package main;

sub preprocess_alltt {
    local ($before, $after, $alltt);
    local ($alltt_begin) = "<alltt_begin>";
    local ($alltt_end) = "<alltt_end>";
    while (/\\begin\s*{alltt}/) {
	$alltt = "";
	($before, $after) = ($`, $');
	if ($after =~ /\\end\s*{alltt}/) {
	    ($alltt, $after) = ($`, $');
	    $alltt = &alltt_helper($alltt)	 # shield special chars
		unless ($before =~ /\n.*%.*$/);  # unless commented out
	    }
	$_ = join('', $before, $alltt_begin, $alltt, $alltt_end, $after);
	}
    s/$alltt_begin/\\begin{alltt}/go;
    s/$alltt_end/\\end{alltt}/go;
    };

sub alltt_helper {
    local ($_) = @_;
    s/^/\\relax/;	# Preserve leading & trailing white space
    s/\t/ /g;		# Remove tabs
    s/\$/;SPMdollar;/g;
    s/\%/;SPMpct;/g;
    s/~/;SPMtilde;/g;
    join('', $_, "\\relax");
    }

sub do_env_alltt {
    local ($_) = @_;
    local($closures,$reopens) = &close_all_tags();
    local(@open_tags,@save_open_tags) = ((),());
    local($cnt) = ++$global{'max_id'};
    $_ = join('',"$O$cnt$C\\tt$O", ++$global{'max_id'}, $C
		, $_ , $O, $global{'max_id'}, "$C$O$cnt$C");
    $_ = &translate_environments($_);
    $_ = &translate_commands($_);
    s/\n/<BR>/g;

#    $_ = &revert_to_raw_tex($_);
#    &mark_string; # ???
#    s/\\([{}])/$1/g; # ???
#    s/<\/?\w+>//g; # no nested tags allowed
#    join('', $closures,"<PRE$env_id>$_</PRE>", $reopens);
    join('', $closures,"<DIV$env_id>", $_, &balance_tags(), '</DIV>', $reopens);
    }

1;	# Must be last line
