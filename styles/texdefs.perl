# Like get_body_newcommand above, but for simple raw TeX \defs

package main;

$meta_cmd_rx =~ s/\)/|def\)/ unless ($meta_cmd_rx =~ /\|def\)/);

sub get_body_def {
    local(*_) = @_;
    local($argn,$cmd,$body,$is_simple_def,$tmp);
    $cmd = &get_next(2);
    $cmd =~ s/^\s*\\//;
    
    $argn = &get_next(3);
    $argn = 0 unless $argn;

    $body = &get_next(1);
    $tmp = "do_cmd_$cmd";
    if ($is_simple_def && !defined (&$tmp))
    { $new_command{$cmd} = join(':!:',$argn,$body,'}'); }
    undef $body;
    $_;
}

######################### Other Concessions to TeX #############################

sub do_cmd_newdimen {
    local($_) = @_;
    local($name, $pat) = &get_next_tex_cmd;
    &add_to_preamble("def", "\\newdimen$pat");
    $_;
}
sub do_cmd_newbox {
    local($_) = @_;
    local($name, $pat) = &get_next_tex_cmd;
    &add_to_preamble("def", "\\newbox$pat");
    $_;
}
sub do_cmd_char {		#JKR: implementation of \char
    local($_) = @_;
    s/^\s*(\d*)\s*/&#\1;/;
    $_;
}

&ignore_commands( <<_IGNORED_CMDS_);
vskip # &ignore_numeric_argument
hskip # &ignore_numeric_argument
kern # &ignore_numeric_argument
bgroup
egroup
_IGNORED_CMDS_


1; 		# Must be last line
