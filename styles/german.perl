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
#           ;SPM<char>; to be consistent with changes in the main script
# 19-Dec-95 Herb Swan: Removed _ from SPM... definitions, consistent with
#	    with new math code of Marcus Hennecke.  Ignore '"|' and '"-'.

package german;
#JKR: print a message.
print "german style interface for LaTeX2HTML, 4.12.95";

# Put german equivalents here for headings/dates/ etc when
# latex2html start supporting them ...


sub main'german_translation {
    local($_) = @_;
    local($next_char_rx) = &make_next_char_rx("[aAeEiIoOuU]");
    s/$next_char_rx/&main'iso_map(($2||$3),"uml")/geo;
    $next_char_rx = &make_next_char_rx("[sSzZ]");
    s/$next_char_rx/&main'iso_map("sz","lig")/geo;
    s/;SPMquot;\s*([cflmnpt])/\1/go;
    s/;SPMquot;\s*(;SPMlt;|;SPMgt;|'|`|\\|-|;SPMquot;|\||~)/&get_german_specials($1)/geo;
    s/;SPMquot;/''/go;
    $_;
}

sub main'do_cmd_3 {
    join('',&main'iso_map("sz", "lig"),@_[0]);
}

sub make_next_char_rx {
    local($chars) = @_;
    local($OP,$CP) = &main'brackets;
    ";SPMquot;\\s*(($chars)|$OP\\d+$CP\\s*($chars)\\s*$OP\\d+$CP)";
}
   
sub get_german_specials {
    $german_specials{@_[0]}
}

%german_specials = (
    ';SPMlt;', ';SPMlt;;SPMlt;',	    
    ';SPMgt;', '&#62;&#62;',
    '\'', "``",
    "\`", ",,",
    '\\', "",
    '-', "",
    '|', "",
    ';SPMquot;', "",
    '~', "",
    '=', ""
);


package main;

sub do_cmd_flqq {
    join('',  ';SPMlt;;SPMlt;',  @_[0]);};
sub do_cmd_frqq {
    join('',  '&#62;&#62;',  @_[0]);};
sub do_cmd_flq {
    join('',  ';SPMlt;',  @_[0]);};
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

#JKR: Prepare the german environment ...
sub german_titles {
    $toc_title = "Inhalt";
    $lof_title = "Abbildungsverzeichnis";
    $lot_title = "Tabellenverzeichnis";
    $idx_title = "Index";
    $bib_title = "Literatur";
    $abs_title = "Zusammenfassung";
    $fig_name = "Abbildung";
    $tab_name = "Tabelle";
    $info_title = "&Uuml;ber dieses Dokument ...";
    @Month = ('', 'Januar', 'Februar', 'M&auml;rz', 'April', 'Mai',
	      'Juni', 'Juli', 'August', 'September', 'Oktober',
	      'November', 'Dezember');  
}

#JKR: Replace do_cmd_today (\today) with a nicer one, which is more
# similar to the original. 
sub do_cmd_today {
    local($today) = (`date "+%m:%d, 20%y"`);
    $today =~ s/(\d{1,2}):0?(\d{1,2}),/$2. $Month[$1]/o;
    $today =~ s/20([7|8|9]\d{1})/19$1/o;
    join('',$today,$_[0]);
}
+
# ... and use it.
&german_titles;
$default_language = 'german';
$TITLES_LANGUAGE = "german";

# MEH: Make iso_latin1_character_map_inv use more appropriate code
$iso_latin1_character_map_inv{'&#196;'} ='"A';
$iso_latin1_character_map_inv{'&#214;'} ='"O';
$iso_latin1_character_map_inv{'&#220;'} ='"U';
$iso_latin1_character_map_inv{'&#228;'} ='"a';
$iso_latin1_character_map_inv{'&#246;'} ='"o';
$iso_latin1_character_map_inv{'&#223;'} ='"s';
$iso_latin1_character_map_inv{'&#252;'} ='"u';

1;				# Not really necessary...



