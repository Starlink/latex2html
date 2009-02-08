### File: html3.1.pl
### Language definitions for HTML 3.1 (Math)
### Written by Marcus E. Hennecke <marcush@leland.stanford.edu>
### Version 0.1,  February 2, 1996

## Copyright (C) 1995 by Marcus E. Hennecke
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

#########################
## Support HTML 3.0 math

#### Mathematical Formulas

sub do_env_math {
    local($math_mode) = "inline";
    "<MATH CLASS=INLINE>" . &make_math(@_) . "</MATH>";
}

sub do_env_tex2html_wrap {
    local($_) = @_;
    local($math_mode) = "inline";
    s/^\\\(//;    s/\\\)$//;
    "<MATH CLASS=INLINE>" . &make_math($_) . "</MATH>";
}

sub do_env_tex2html_wrap_inline {
    local($_) = @_;
    local($math_mode) = "inline";
    s/^\$//; chop;
    "<MATH CLASS=INLINE>" . &make_math($_) . "</MATH>";
}

sub do_env_equation {
    local($math_mode) = "equation";
    "<P ALIGN=CENTER><MATH CLASS=EQUATION>" . &make_math(@_) . "</MATH></P>";
}

sub do_env_displaymath {
    local($math_mode) = "displaymath";
    "<P ALIGN=CENTER><MATH CLASS=DISPLAYMATH>" . &make_math(@_) . "</MATH></P>";
}

### Some Common Structures

## Declare math mode and take care of sub- and superscripts. Also make
## sure to treat curly braces right.
sub make_math {
    local($_) = @_;
    
    # Do spacing
    s/\\,/;SPMthinsp;/g;
    s/\\!//g;
    s/\\:/;SPMsp;/g;
    s/\\;/;SPMthicksp;/g;

    # Find all _ and ^, but not \_ and \^
    s/\\_/\\underscore/g;
    s/\\^/\\circflex/g;
    local(@terms) = split(/([_^])/);
    local($math,$i,$subsup,$level);
    # Do the sub- and superscripts
    $math = $terms[$[];
    for ( $i = $[+1; $i <= $#terms; $i+=2 ) {
	$subsup = ( $terms[$i] eq "_" ? "SUB" : "SUP" );
	$_ = $terms[$i+1];
	if ( s/$next_pair_rx// ) {
	    $math .= "<$subsup>$2</$subsup>$_";
	} else {
	    s/^\s*(\w|\\[a-zA-Z]+)//;
	    $math .= "<$subsup>$1</$subsup>$_";
	};
    };
    $_ = $math;
    s/\\underscore/\\_/g;
    s/\\circflex/\\^/g;
    # Translate all commands inside the math environment
    $_ = &translate_commands($_);
    # Inside <MATH>, { and } have special meaning. Thus, need &lcub;
    # and &rcub;
    s/{/&lcub;/g;
    s/}/&rcub;/g;
    # Substitute <BOX> and </BOX> with { and } to improve readability
    # on browsers that do not support math.
#    s/<\/?SUB>/_/g;
#    s/<\/?SUP>/^/g;
    s/<BOX>/$level++;'{'/ge;
    s/<\/BOX>/$level--;'}'/ge;
    # Make sure braces are matching.
    $_ .= '}' if ( $level > 0 );
    $_ = '{'.$_ if ( $level < 0 );
    # Remove empty lines (no paragraphs)
    s/\n\s*\n/\n/g;
    $_;
}

## Fractions
sub do_math_cmd_frac {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    local($numerator) = $2;
    s/$next_pair_pr_rx//;
    "<BOX>$numerator<OVER>$2</BOX>$_";
}

## Roots
sub do_math_cmd_sqrt {
    local($_) = @_;
    local($n) = &get_next_optional_argument;
    s/$next_pair_pr_rx//;
    $n ? "<ROOT>$n<OF>$2</ROOT>$_" : "<SQRT>$2</SQRT>$_";
}

%mathentities = (
		 # Ellipsis
		 'ldots', 'ldots', 'cdots', 'cdots', 'vdots', 'vdots',
		 'ddots', 'ddots', 'dotfill', 'dotfill',

### Mathematical Symbols
		 # Greek letters
		 'alpha', 'alpha', 'beta', 'beta', 'gamma', 'gamma',
		 'delta', 'delta', 'epsilon', 'epsi', 'varepsilon', '',
		 'zeta', 'zeta', 'eta', 'eta', 'theta', 'theta',
		 'vartheta', 'thetav', 'iota', 'iota', 'kappa', 'kappa',
		 'lambda', 'lambda', 'mu', 'mu',
		 'nu', 'nu', 'xi', 'xi', 'pi', 'pi', 'varpi', 'piv',
		 'rho', 'rho', 'varrho', '', 'sigma', 'sigma',
		 'varsigma', 'sigmav', 'tau', 'tau', 'upsilon', 'upsi',
		 'phi', 'phi', 'varphi', 'phiv', 'chi', 'chi',
		 'psi', 'psi', 'omega', 'omega',
		 'Gamma', 'Gamma', 'Delta', 'Delta', 'Theta', 'Theta',
		 'Lambda', 'Lambda', 'Xi', 'Xi', 'Pi', 'Pi',
		 'Sigma', 'Sigma', 'Upsilon', 'Upsi', 'Phi', 'Phi',
		 'Psi', 'Psi', 'Omega', 'Omega',
		 # Binary operators
		 'pm', 'plusmn', 'vee', 'or', 'wedge', 'and',
		 # Relations
		 'perp', 'perp', 'leq', 'le', 'propto', 'prop',
		 'geq', 'ge', 'equiv', 'equiv', 'approx', 'ap',
		 'neq', 'ne', 'subset', 'sub', 'subseteq', 'sube',
		 'supset', 'sup', 'supseteq', 'supe', 'in', 'isin',
		 # Arrows and pointers
		 'leftarrow', 'larr', 'rightarrow', 'rarr',
		 'uparrow', 'uarr', 'downarrow', 'darr',
		 'Leftarrow', 'lArr', 'Rightarrow', 'rArr',
		 'Uparrow', 'uArr', 'Downarrow', 'dArr',
		 'leftrightarrow', 'harr', 'Leftrightarrow', 'hArr',
		 'gets', 'larr', 'to', 'rarr', 'iff', 'iff',
		 'longleftarrow', 'larr', 'longrightarrow', 'rarr',
		 'Longleftarrow', 'lArr', 'Longrightarrow', 'rArr',
		 'longleftrightarrow', 'harr', 'Longleftrightarrow', 'iff',
		 # Various other symbols
		 'emptyset', 'empty', 'forall', 'forall', 'exists', 'exist',
		 'infty', 'inf', 'nabla', 'nabla', 'partial', 'pd',
		 'qquad', 'quad',
		 # Integral type entities
		 'int', 'int', 'sum', 'sum', 'prod', 'prod'
);

## Log-like Functions
@mathfunctions = ('arccos', 'arcsin', 'arctan', 'arg', 'cos', 'cosh',
		  'cot', 'coth', 'csc', 'deg', 'dim', 'exp', 'hom',
		  'ker', 'lg', 'ln', 'log', 'sec', 'sin', 'sinh',
		  'tan', 'tanh', 'mod');
@limitfunctions = ('det', 'gcd', 'inf', 'lim', 'liminf',
		   'limsup', 'max', 'min', 'Pr', 'sup' );

foreach (@mathfunctions) {
    eval "sub do_math_cmd_$_\{\"<T CLASS=FUNCTION>$_</T>\$_[\$[]\";}";
}
foreach (@limitfunctions) {
    eval "sub do_math_cmd_$_\{
    local(\$_) = \@_;
    s/^\\s*<SUB>/<SUB ALIGN=CENTER>/ unless ( \$math_mode eq \"inline\" );
    \"<T CLASS=FUNCTION>$_</T>\$_\";}";
}

sub do_math_cmd_pmod {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "(<T CLASS=FUNCTION>mod</T> $2)$_";
 }
 
 sub do_math_cmd_circ {
     "o@_";
}

### Arrays
sub do_env_array {
    local($_) = @_;
    local($align) = &get_next_optional_argument;
    if      ( $align =~ /^\s*b/ ) {
	$align = "ALIGN=BOTTOM";
    } elsif ( $align =~ /^\s*t/ ) {
	$align = "ALIGN=TOP";
    } else {
	$align = "ALIGN=MIDDLE";
    };
    s/$next_pair_rx//;
    local($colspec) = $2;
    s/\n\s*\n/\n/g;	# Remove empty lines (otherwise will have paragraphs!)
    local($i,@colspec,$char,$cols,$cell,$htmlcolspec,$frames,$rules);
    local(@rows,@cols,$border);
    local($colspan);
    
    ($htmlcolspec,$frames,$rules,$cols,@colspec) =
	&translate_colspec($colspec, 'ITEM');

    @rows = split(/\\\\|\\newline/);
    $#rows-- if ( $rows[$#rows] =~ /^\s*$/ );
    local($return) = "<ARRAY COLS=$cols $align>\n$htmlcolspec\n";
    foreach (@rows) {
	$return .= "<ROW>";
	@cols = split(/$html_specials{'&'}/o);
	for ( $i = 0; $i <= $#colspec; $i++ ) {
	    $colspec = $colspec[$i];
	    $colspan = 0;
	    $cell = &make_math(shift(@cols)); # May modify $colspan, $colspec
	    if ( $colspan ) {
		for ( $cellcount = 0; $colspan > 0; $colspan-- ) {
		    $colspec[$i++] =~ s/<ITEM/$cellcount++;"<ITEM"/ge;
		}
		$i--;
		$colspec =~ s/>$content_mark/ COLSPAN=$cellcount$&/;
	    };
	    $colspec =~ s/$content_mark/$cell/;
	    $return .= $colspec;
	};
	$return .= "</ROW>\n";
    };
    $return .= "</ARRAY>\n";
    $return;
}

### Delimiters

$math_delimiters_rx = "^\\s*(\\[|\\(|\\\\{|\\\\lfloor|\\\\lceil|\\\\langle|\\/|\\||\\)|\\]|\\\\}|\\\\rfloor|\\\\rceil|\\\\rangle|\\\\backslash|\\\\\\||\\\\uparrow|\\\\downarrow|\\\\updownarrow|\\\\Uparrow|\\\\Downarrow|\\\\Updownarrow|\\.)";

sub do_math_cmd_left {
    local($_) = @_;
    s/$math_delimiters_rx//;
    "<BOX>" . ( $1 && $1 ne "." ? "$1<LEFT>" : "" ) . $_ .
	( /\\right/ ? "" : "</BOX>" );
}

sub do_math_cmd_right {
    local($_) = @_;
    s/$math_delimiters_rx//;
    if ( !($ref_before =~ /<LEFT>/) ) {
	$ref_before = "<BOX>" . $ref_before;
    };
    ( $1 eq "." ? "" : "<RIGHT>$1" ) . "</BOX>$_";
}

### Multiline formulas

sub do_env_eqnarray {
    local($_) = @_;
    local($math_mode) = "equation";
    local($max_id) = ++$global{'max_id'};
    "<P ALIGN=CENTER><MATH CLASS=EQNARRAY>" .
	&do_env_array("$O$max_id${C}rcl$O$max_id$C$_") .
	    "</MATH></P>";
}

sub do_env_eqnarraystar {
    local($_) = @_;
    local($math_mode) = "displaymath";
    local($max_id) = ++$global{'max_id'};
    "<P ALIGN=CENTER><MATH CLASS=EQNARRAYSTAR>" .
	&do_env_array("$O$max_id${C}rcl$O$max_id$C$_") .
	    "</MATH></P>";
}

sub do_math_cmd_nonumber {
    $_[$[];
};

### Putting One Thing Above Another

## Over- and Underlining

sub do_math_cmd_overline {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<ABOVE>$2</ABOVE>$_";
}

sub do_math_cmd_underline {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<BELOW>$2</BELOW>$_";
}

sub do_math_cmd_overbrace {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<ABOVE SYM=CUB>$2</ABOVE>$_";
}

sub do_math_cmd_underbrace {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<BELOW SYM=CUB>$2</BELOW>$_";
}

## Accents

sub do_math_cmd_vec {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<VEC>$2</VEC>$_";
}

sub do_math_cmd_bar {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<BAR>$2</BAR>$_";
}

sub do_math_cmd_dot {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<DOT>$2</DOT>$_";
}

sub do_math_cmd_ddot {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<DDOT>$2</DDOT>$_";
}

sub do_math_cmd_hat {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<HAT>$2</HAT>$_";
}

sub do_math_cmd_tilde {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<TILDE>$2</TILDE>$_";
}

sub do_math_cmd_widehat {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<ABOVE SYM=HAT>$2</ABOVE>$_";
}

sub do_math_cmd_widetilde {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<ABOVE SYM=TILDE>$2</ABOVE>$_";
}

## Stacking Symbols

sub do_math_cmd_stackrel {
    local ($_) = @_;
    s/$next_pair_pr_rx//;
    local($top) = $2;
    s/$next_pair_pr_rx//;
    "<BOX>$2</BOX><SUB ALIGN=CENTER>$top</SUB>$_";
}

# Kill $ref_before in case we're not in math mode.
sub do_math_cmd_atop {
    local ($before) = $ref_before;
    $ref_before = "";
    "<BOX>$before<ATOP>$_[$[]</BOX>";
}

sub do_math_cmd_choose {
    local ($before) = $ref_before;
    $ref_before = "";
    "<BOX>$before<CHOOSE>$_[$[]</BOX>";
}

sub do_math_cmd_mbox {
    local($_) = @_;
    s/$next_pair_pr_rx//;
    "<TEXT>$2</TEXT>$_";
}

sub do_math_cmd_display {
    $_[$[];
}

sub do_math_cmd_text {
    $_[$[];
}

sub do_math_cmd_script {
    $_[$[];
}

sub do_math_cmd_scriptscript {
    $_[$[];
}

# This is supposed to put the font back into math italics.
# Since there is no HTML equivalent for reverting 
# to math italics we keep track of the open font tags in 
# the current context and close them.
# *** POTENTIAL ERROR ****#  
# This will produce incorrect results in the exceptional
# case where \mit is followed by another context
# containing font tags of the type we are trying to close
# e.g. {a \bf b \mit c {\bf d} e} will produce
#       a <b> b </b> c   <b> d   e</b>
# i.e. it should move closing tags from the end 
sub do_math_cmd_mit {
    local($_, @open_font_tags) = @_;
    local($next);
    for $next (@open_font_tags) {
	$next = ($declarations{$next});
	s/<\/$next>//;
	$_ = join('',"<\/$next>",$_);
    }
    $_;
}

$HTML_VERSION = "3.0" if $HTML_VERSION eq "3.1";
