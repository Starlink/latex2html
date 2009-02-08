# GERMAN.PERL by Nikos Drakos <nikos@cbl.leeds.ac.uk> 25-11-93
# Computer Based Learning Unit, University of Leeds.
#
# Extension to LaTeX2HTML to translate LaTeX german special 
# commands to equivalent HTML commands.
# Based on a patch to LaTeX2HTML supplied by  Franz Vojik 
# <vojik@de.tu-muenchen.informatik>. 
#
# The original german.sty file was put together by H.Partl 
# (TU Wien) 4 Nov 1988
#
# Change Log:
# ===========
#
# 11-JAN-94 Nikos Drakos: Modified the german specials array to
#           deal with "` correctly
# 25-JAN-94 Nikos Drakos: Replaced all the html special characters
#           with their ;tex2html_html_special_mark_<chars> form
# 13-Dec-94 Nikos Drakos Replaced ;tex2html_html_special_mark_<char>; with
#           ;SPM_<char>; to be consistent with changes in the main script

package german;

# Put german equivalents here for headings/dates/ etc when
# latex2html start supporting them ...


sub main'german_translation {
    local($_) = @_;
    local($next_char_rx) = &make_next_char_rx("[aAeEiIoOuU]");
    s/$next_char_rx/&main'iso_map(($2||$3),"uml")/geo;
    $next_char_rx = &make_next_char_rx("[sSzZ]");
    s/$next_char_rx/&main'iso_map("sz","lig")/geo;
    s/;SPM_quot;\s*([cflmnpt])/\1/go;
    s/;SPM_quot;\s*(;SPM_lt;|;SPM_gt;|'|`|\\|-|;SPM_quot;|~)/&get_german_specials($1)/geo;
    s/;SPM_quot;/''/go;
    $_;
}

sub main'do_cmd_3 {
    join('',&main'iso_map("sz", "lig"),@_[0]);
}

sub make_next_char_rx {
    local($chars) = @_;
    local($OP,$CP) = &main'brackets;
    ";SPM_quot;\\s*(($chars)|$OP\\d+$CP\\s*($chars)\\s*$OP\\d+$CP)";
}
   
sub get_german_specials {
    $german_specials{@_[0]}
}

%german_specials = (
    ';SPM_lt;', ';SPM_lt;;SPM_lt;',	    
    ';SPM_gt;', '&#62;&#62;',
    '\'', "``",
    "\`", ",,",
    '\\', "",
    '-', "",
    ';SPM_quot;', "",
    '~', "",
    '=', ""
);


package main;

sub do_cmd_flqq {
    join('',  ';SPM_lt;;SPM_lt;',  @_[0]);};
sub do_cmd_frqq {
    join('',  '&#62;&#62;',  @_[0]);};
sub do_cmd_flq {
    join('',  ';SPM_lt;',  @_[0]);};
sub do_cmd_frq {
    join('',  '&#62;',  @_[0]);};
sub do_cmd_glqq {
    join('',  ",,",  @_[0]);};
sub do_cmd_grqq {
    join('',  "``",  @_[0]);};
sub do_cmd_glq {
    join('',  ",",  @_[0]);};
sub do_cmd_grq {
    join('',  "`",  @_[0]);};
sub do_cmd_dq {
    join('',  "''",  @_[0]);};

sub do_cmd_germanTeX {
    # Just in case we pass things to LaTeX
    $default_language = 'german';
    $latex_body .= "\\germanTeX\n";
    @_[0];
}

sub do_cmd_originalTeX {
    # Just in case we pass things to LaTeX
    $default_language = 'original';
    $latex_body .= "\\originalTeX\n";
    @_[0];
}

$default_language = 'german';

1;				# Not really necessary...



