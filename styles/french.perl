# FRENCH.PERL by Nikos Drakos <nikos@cbl.leeds.ac.uk> 25-11-93
# Computer Based Learning Unit, University of Leeds.
#
# Extension to LaTeX2HTML to translate LaTeX french special 
# commands to equivalent HTML commands and ISO-LATIN-1 characters.
# Based on a patch to LaTeX2HTML supplied by  Franz Vojik 
# <vojik@de.tu-muenchen.informatik>. 
#
# Change Log:
# ===========
#
# 11-MAR-94 Nikos Drakos - Added support for \inferieura and \superrieura

package french;

# Put french equivalents here for headings/dates/ etc when
# latex2html start supporting them ...

sub main'french_translation {
    @_[0];
}

package main;

sub do_cmd_frenchTeX {
    # Just in case we pass things to LaTeX
    $default_language = 'french';
    $latex_body .= "\\frenchTeX\n";
    @_[0];
}

sub do_cmd_originalTeX {
    # Just in case we pass things to LaTeX
    $default_language = 'original';
    $latex_body .= "\\originalTeX\n";
    @_[0];
}

sub do_cmd_inferieura {
   "&lt @_[0]"
}
 
sub do_cmd_superrieura {
   "&gt @_[0]"
}


$default_language = 'french';

1;				# Not really necessary...



