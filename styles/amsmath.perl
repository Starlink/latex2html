# amstex.perl by Ross Moore <ross@mpce.mq.edu.au>  9-30-96
#
# Extension to LaTeX2HTML to load features from AMS-LaTeX
#   amsfonts, amssymb, eucal, eufrak or euscript. 
#
# Change Log:
# ===========
#
# $Log: amsmath.perl,v $
# Revision 1.15  1998/02/20 22:02:06  latex2html
# added log
#
# Revision 1.14  1998/02/20 22:00:42  latex2html
# added log
#
# Revision 1.13  1998/02/20 21:58:51  latex2html
# added log
#
# revision 1.12
# date: 1998/02/13 12:57:35;  author: latex2html;  state: Exp;  lines: +11 -0
#  --  images of {subequations} have the correct numbering and alignment
# ----------------------------
# revision 1.11
# date: 1998/02/06 22:57:15;  author: latex2html;  state: Exp;  lines: +39 -2
#  --  copied &get_eqn_number from the  more_amsmath file
# ----------------------------
# revision 1.10
# date: 1998/01/27 11:33:23;  author: RRM;  state: Exp;  lines: +30 -16
#  --  \title needed updating, in line with changes in  latex2html
# ----------------------------
# revision 1.9
# date: 1998/01/19 08:52:33;  author: RRM;  state: Exp;  lines: +3 -746
#  	That part of  amstex.perl and amsmath.perl that needs the `math'
# 	extension has been split-off into  more_amsmath.perl .
# 	This is loaded automatically with switches:
# 		 -no_math -html_version ...,math
# ----------------------------
# revision 1.8
# date: 1998/01/14 01:20:22;  author: RRM;  state: Exp;  lines: +16 -7
#  --  bringing up-to-date with  amstex.perl
# ----------------------------
# revision 1.7
# date: 1997/12/18 11:18:33;  author: RRM;  state: Exp;  lines: +14 -9
#  --  removed  do_cmd_numberwithin  which is in the  latex2html  script
#  --  added support for CLASS="MATH"  with $USING_STYLES
# ----------------------------
# revision 1.6
# date: 1997/12/17 10:26:27;  author: RRM;  state: Exp;  lines: +30 -16
#  --  this file should be identical to  amstex.perl
# ----------------------------
# revision 1.5
# date: 1997/12/11 02:44:33;  author: RRM;  state: Exp;  lines: +1 -1
#  --  bringing this file up-to-date with  amstex.perl
# ----------------------------
# revision 1.4
# date: 1997/10/14 13:14:43;  author: RRM;  state: Exp;  lines: +10 -2
#  --  bringing this file up-to-date with  amstex.perl
# ----------------------------
# revision 1.3
# date: 1997/10/05 08:37:36;  author: RRM;  state: Exp;  lines: +742 -17
#  --  making sure this file is identical to  amstex.perl
# ----------------------------
# revision 1.2
# date: 1997/07/11 11:28:59;  author: RRM;  state: Exp;  lines: +19 -19
#  -  replace  (.*) patterns with something allowing \n s included
# ----------------------------
# revision 1.1
# date: 1997/05/19 13:53:34;  author: RRM;  state: Exp;
#      New file;  same as  amstex.perl


package main;
#


# unknown environments:  alignedat, gathered, alignat, multline
#   \gather([^* ])...\endgather
#   \align([^* ])...\endalign

$abstract_name = "Abstract";
$keywords_name = "Keywords";
$subjclassname = "1991 Subject Classification";
$date_name = "Date published";
$Proof_name = "Proof";


sub do_cmd_title {
    local($_) = @_;
    local($text,$s_title,$rest);
    if (/\\endtitle/) {
	$rest = $';
	$t_title = $text = &translate_commands($`);
	$t_title =~ s/(^\s*|\s*$)//g;
	$s_title = &simplify($text);
	$TITLE = (($s_title)? $s_title : $default_title);
	return($rest);
    }
    &get_next_optional_argument;
    $text = &missing_braces
        unless ((s/$next_pair_pr_rx//o)&&($text = $2));
    $t_title = &translate_environments($text);
    $t_title = &translate_commands($t_title);
    $s_title = &simplify(&translate_commands($text));
    $TITLE = (($s_title)? $s_title : $default_title);
    $_
}

#    local($rest) = $_;
#    $rest =~ s/$next_pair_pr_rx//o;
#    $_ =  &translate_commands($&);
#    &extract_pure_text("liberal");
#    s/([\w\W]*)(<A.*><\/A>)([\w\W]*)/$1$3/;  # HWS:  Remove embedded anchors
#    ($t_title) = $_;
#    $TITLE = $t_title if ($TITLE eq $default_title);
#    $TITLE =~ s/<P>//g;		# Remove Newlines
#    $TITLE =~ s/\s+/ /g;	# meh - remove empty lines 
#    $rest;
#}

sub do_cmd_author {
    local($_) = @_;
    if (/\\endauthor/) {
	$t_author = &translate_commands($`);
	$t_author =~ s/(^\s*|\s*$)//g;
	return($');
    }
    &get_next_optional_argument;
    local($rest) = $_;
    $rest =~ s/$next_pair_pr_rx//o;
    ($t_author) =  &translate_commands($&);
    $rest;
}

sub do_cmd_address {
    local($_) = @_;
    if (/\\endaddress/) {
	$t_address = &translate_commands($`);
	$t_address =~ s/(^\s*|\s*$)//g;
	return($');
    }
    &get_next_optional_argument;
    local($rest) = $_;
    $rest =~ s/$next_pair_pr_rx//o;
    ($t_address) =  &translate_commands($&);
    $rest;
}

sub do_cmd_curraddr {
    local($_) = @_;
    &get_next_optional_argument;
    local($rest) = $_;
    $rest =~ s/$next_pair_pr_rx//o;
    ($t_curraddr) =  &translate_commands($&);
    $rest;
}

sub do_cmd_affil {
    local($_) = @_;
    if (/\\endaffil/) {
	$t_affil = &translate_commands($`);
	$t_affil =~ s/(^\s*|\s*$)//g;
	return($');
    }
    &get_next_optional_argument;
    local($rest) = $_;
    $rest =~ s/$next_pair_pr_rx//o;
    ($t_curraddr) = &translate_commands($&);
    $rest;
}

sub do_cmd_dedicatory {
    local($_) = @_;
    &get_next_optional_argument;
    local($rest) = $_;
    $rest =~ s/$next_pair_pr_rx//o;
    ($t_affil) = &translate_commands($&);
    $rest;
}

sub do_cmd_date {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($t_date) = &translate_commands($&);
    $_;
}

sub do_cmd_email {
    local($_) = @_;
    &get_next_optional_argument;
    local($rest) = $_;
    $rest =~ s/$next_pair_pr_rx//o;
    ($t_email) = &make_href("mailto:$2","$2");
    $rest;
}

sub do_cmd_urladdr {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($t_authorURL) = &translate_commands($2);
    $_;
}

sub do_cmd_keywords {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($t_keywords) = &translate_commands($2);
    $_;
}

sub do_cmd_subjclass {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($t_subjclass) = &translate_commands($2);
    $_;
}

sub do_cmd_translator {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($t_translator) = &translate_commands($2);
    $_;
}

sub do_cmd_MR {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($t_math_rev) = &translate_commands($2);
    $_;
}

sub do_cmd_PII {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($t_publ_index) = &translate_commands($2);
    $_;
}

sub do_cmd_copyrightinfo {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($t_copyright_year) = &translate_commands($2);
    s/$next_pair_pr_rx//o;
    ($t_copyright_holder) = &translate_commands($2);
    $_;
}



sub do_cmd_AmS {
    local($_) = @_;
    "<i>AmS</i>".$_;
}

sub do_cmd_AmSTeX {
    local($_) = @_;
    "<i>AmS-TeX</i>" . $_;
}

sub do_cmd_maketitle {
    local($_) = @_;
    local($the_title) = '';
    if ($t_title) {
	$the_title .= "<H1 ALIGN=CENTER>$t_title</H1>\n";
    } else { &write_warnings("This document has no title."); }
    if ($t_author) {
	$the_title .= "<P ALIGN=CENTER><STRONG>$t_author</STRONG></P>\n";
    } else { &write_warnings("There is no author for this document."); }
    if ($t_translator) {
	$the_title .= "<BR><P ALIGN=CENTER>Translated by $t_translator</P>\n";}
    if ($t_affil) {
	$the_title .= "<BR><P ALIGN=CENTER><I>$t_affil</I></P>\n";}
    if ($t_date) {
	$the_title .= "<BR><P ALIGN=CENTER><I>Date:</I> $t_date</P>\n";}

    if ($t_address) {
	$the_title .= "<BR><P ALIGN=LEFT><FONT SIZE=-1>$t_address</FONT></P>\n";
    } else { $the_title .= "<P ALIGN=LEFT>"}
    if ($t_email) {
	$the_title .= "<P ALIGN=LEFT><FONT SIZE=-1>$t_email</FONT></P>\n";
    } else { $the_title .= "</P>" }
    if ($t_keywords) {
	$the_title .= "<BR><P><P ALIGN=LEFT><FONT SIZE=-1>".
	    "Key words and phrases: $t_keywords</FONT></P>\n";}
    if ($t_subjclass) {
	$the_title .= "<BR><P><P ALIGN=LEFT><FONT SIZE=-1>".
	    "1991 Mathematics Subject Classification: $t_subjclass</FONT></P>\n";}

    $the_title . $_ ;
}



sub do_cmd_boldsymbol {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    $_ = join('',"<B><I>$2</I></B>",$_);
    $_;
}



# some simplifying macros that like
# to existing LaTeX constructions.
# are defined already in  latex2html 

#sub do_cmd_eqref {
#    local($_) = @_;
#    join('','(',&process_ref($cross_ref_mark,$cross_ref_mark,'',')'));
#}

#sub do_cmd_numberwithin {
#    local(*_) = @_;
#    local($ctr, $within);
#    $ctr = &get_next(1);
#    $within = &get_next(1);
#    &addto_dependents($within,$ctr) if ($within);
#    $_;
#}

#########  for equation-numbers and tags  ###############

sub get_eqn_number {
    local($outer_num, $scan) = @_;
    # an explicit \tag overrides \notag , \nonumber or *-variant
    local($labels,$tag);
    ($scan,$labels) = &extract_labels($scan); # extract labels
    $scan =~ s/\n//g;
    if ($scan =~ s/\\tag(\*|star\b)?\s*(($O|$OP)\d+($C|$CP))(.*)\2//) {
	local($star) = $1; $tag = $5;
	$tag = &translate_environments($tag) if ($tag =~ /\\begin/);
	$tag = &translate_commands($tag) if ($tag =~ /\\/);
	$tag = (($star)? $tag : $EQNO_START.$tag.$EQNO_END );
    } elsif (($outer_num)&&(!($scan)||!($scan =~ s/\\no(tag|number)//))
	&&(!($scan =~ /^\s*\\begin(<(<|#)\d+(>|#)>)($outer_math_rx)/))
      ) { 
        $global{'eqn_number'}++ ;
	if ($subequation_level) {
	    local($sub_tag) =  &get_counter_value('equation');
	    $tag = join('', $EQNO_START
		, $eqno_prefix
		, &falph($sub_tag)
		, $EQNO_END);
	} else {
	    $tag = join('', $EQNO_START
		, &simplify(&translate_commands("\\theequation"))
		, $EQNO_END);
	}
    } else { $tag = ';SPMnbsp;' }
    $*=0;
    if ($labels) {
	$labels =~ s/$anchor_mark/$tag/o;
	($labels , $scan);
    } else { ($tag , $scan) }
}

###   Special environments, for mathematics

sub do_env_equationstar {
    local($no_eqn_numbers) = 1;
    &do_env_displaymath(@_);
}
sub do_env_subequations {
    $latex_body .= join('', "\n\\setcounter{equation}{"
		, $global{'eqn_number'} , "}\n");
    $global{'eqn_number'}++;
    local($this) = &process_undefined_environment('subequations'
	    , ++$global{'max_id'}, @_);
    local($div) = (($HTML_VERSION < 3.2)? 'P' : 'DIV');
    join('', '<P ALIGN="' 
	    , (($EQN_TAGS =~ /L/)? 'LEFT' : 'RIGHT')
	    , "\">\n" , $this, '<BR></P>' )
}


#  Suppress the possible options to   \usepackage[....]{amstex}
#  and  {amsmath}  {amsopn}  {amsthm}

sub do_amstex_noamsfonts {
}
sub do_amstex_psamsfonts {
}
sub do_amstex_intlimits {
}
sub do_amstex_nointlimits {
}
sub do_amstex_intlim {
}
sub do_amstex_nosumlim {
}
sub do_amstex_nonamelim {
}
sub do_amstex_nolimits {
}
sub do_amstex_sumlimits {
}
sub do_amstex_nosumlimits {
}
sub do_amstex_namelimits {
}
sub do_amstex_nonamelimits {
}
sub do_amstex_leqno { $EQN_TAGS = 'L'; }
sub do_amstex_reqno { $EQN_TAGS = 'R'; }
sub do_amsmath_leqno { $EQN_TAGS = 'L'; }
sub do_amsmath_reqno { $EQN_TAGS = 'R'; }
sub do_amsmath_fleqn {}
sub do_amstex_centereqn {
}
sub do_amstex_centertags {
}
sub do_amstex_tbtags {
}
sub do_amstex_righttag {
}
sub do_amstex_ctagsplt {
}


%AMSenvs = (
	  'cases' , 'endcases'
	, 'matrix'  , 'endmatrix'
	, 'bmatrix' , 'endbmatrix'
	, 'Bmatrix' , 'endBmatrix'
	, 'pmatrix' , 'endpmatrix'
	, 'vmatrix' , 'endvmatrix'
	, 'Vmatrix' , 'endVmatrix'
	, 'smallmatrix' , 'endsmallmatrix'
	, 'align'    , 'endalign'
	, 'alignat'  , 'endalignat'
	, 'xalignat' , 'endxalignat'
	, 'xxalignat', 'endxxalignat'
	, 'aligned'  , 'endaligned'
	, 'topaligned'  , 'endtopaligned'
	, 'botaligned'  , 'endbotaligned'
	, 'alignedat', 'endalignedat'
	, 'flalign'  , 'endflalign'
	, 'gather'   , 'endgather'
	, 'multline' , 'endmultline'
	, 'heading' , 'endheading'
	, 'proclaim' , 'endproclaim'
	, 'demo' , 'enddemo'
	, 'roster' , 'endroster'
	, 'ref' , 'endref'
);


&ignore_commands( <<_IGNORED_CMDS_);
comment # <<\\endcomment>>
displaybreak
allowdisplaybreak
allowdisplaybreaks
spreadlines
overlong
allowtthyphens
hyphenation
BlackBoxes
NoBlackBoxes
split
operatorname
qopname # {} # {}
text
thetag
mspace # {}
smash # []
topsmash
botsmash
medspace
negmedspace
thinspace
negthinspace
thickspace
negthickspace
hdots
hdotsfor # &ignore_numeric_argument
hcorrection # &ignore_numeric_argument
vcorrection # &ignore_numeric_argument
topmatter
endtopmatter
overlong
nofrills
phantom # {}
hphantom # {}
vphantom # {}
minCDarrowwidth # {}
chapterrunhead # {} # {} # {}
sectionrunhead # {} # {} # {}
partrunhead # {} # {} # {}
_IGNORED_CMDS_


&process_commands_in_tex (<<_RAW_ARG_CMDS_);
cases # <<\\endcases>>
matrix # <<\\endmatrix>>
bmatrix # <<\\endbmatrix>>
Bmatrix # <<\\endBmatrix>>
pmatrix # <<\\endpmatrix>>
vmatrix # <<\\endvmatrix>>
Vmatrix # <<\\endVmatrix>>
smallmatrix # <<\\endsmallmatrix>>
align # <<\\endalign>>
alignat # <<\\endalignat>>
xalignat # <<\\endxalignat>>
xxalignat # <<\\endxxalignat>>
aligned # <<\\endaligned>>
alignedat # <<\\endalignedat>>
flalign # <<\\endflalign>>
gather # <<\\endgather>>
multline # <<\\endmultline>>
overset # {} # {}
sideset # {} # {}
underset # {} # {}
overleftarrow # {}
overrightarrow # {}
oversetbrace # <<\\to>> # {}
undersetbrace # <<\\to>> # {}
lcfrac # <<\\endcfrac>>
rcfrac # <<\\endcfrac>>
cfrac # <<\\endcfrac>>
CD # <<\\endCD>>
fracwithdelims # &ignore_numeric_argument(); # {} # {}
thickfrac # <<\\thickness>> # &ignore_numeric_argument(); # {} # {}
thickfracwithdelims # <<\\thickness>> # &ignore_numeric_argument(); # {} # {}
boxed # {}
mathbb # {}
mathfrak # {}
_RAW_ARG_CMDS_

&process_commands_inline_in_tex (<<_RAW_ARG_CMDS_);
_RAW_ARG_CMDS_


&process_commands_nowrap_in_tex (<<_RAW_ARG_NOWRAP_CMDS_);
numberwithin # {} # {}
_RAW_ARG_NOWRAP_CMDS_


#   add later extensions, which require `math' to be loaded

if (($NO_SIMPLE_MATH)&&(defined &make_math)) { 
    print "\nLoading $LATEX2HTMLSTYLES/more_amsmath.perl";
    require "$LATEX2HTMLSTYLES/more_amsmath.perl";
}


1;                              # This must be the last line

