# MAKEINDEX.PERL by Nikos Drakos <nikos@cbl.leeds.ac.uk> 30-11-93
# Computer Based Learning Unit, University of Leeds.
#
# Extension to LaTeX2HTML to translate makeindex 
# commands to equivalent HTML commands.
#
# The Perl code was written by Axel Belinfante 
# <Axel.Belinfante@cs.utwente.nl> 
#
# 25-JAN 1994 Modified by Nikos Drakos to use ;tex2html_html_special_mark_mark_quot;
# instead of &quot;

sub add_idx {
    print "\nDoing the index ...";
    local($key, @keys, $next, $index);
    @keys = keys %index;
    @keys = sort @keys;
    @keys = grep(!/\001/, @keys);
    foreach $key (@keys) {
        $index .= &add_idx_key($key);
    }
    s/$idx_mark/<DL>$index<\/DL>/o;
}
 
sub add_idx_key {
    local($key) = @_;
    local($index, $next);
    if ($index{$key}) {
        $next = "<DT>$printable_key{$key}<DD>" . $index{$key};
        $next =~ s/[,] $/\n/;   # Get rid of the last comma-space
        $index .= $next;
        $index_printed{$key} = 1;
    }
    if ($sub_index{$key}) {
        local($subkey, @subkeys, $subnext, $subindex);
        @subkeys = sort(split("\004", $sub_index{$key}));
        $index .= "<DT>$printable_key{$key}<DD>" unless $index_printed{$key};
        $index .= "<DL>";
        foreach $subkey (@subkeys) {
            $index .= &add_idx_key($subkey);
        }
        $index .= "</DL>";
    }
    return $index;
}

sub do_cmd_index {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    local($br_id, $str) = ($1, $2);
    # escape the quoting etc characters
    # ! -> \001
    # @ -> \002
    # | -> \003
    $str =~ s/\\\\/\011/g;
    $str =~ s/\\;tex2html_html_special_mark_quot;/\012/g;
    $str =~ s/;tex2html_html_special_mark_quot;!/\013/g;
    $str =~ s/!/\001/g;
    $str =~ s/\013/!/g;
    $str =~ s/;tex2html_html_special_mark_quot;@/\015/g;
    $str =~ s/@/\002/g;
    $str =~ s/\015/@/g;
    $str =~ s/;tex2html_html_special_mark_quot;\|/\017/g;
    $str =~ s/\|/\003/g;
    $str =~ s/\017/|/g;
    $str =~ s/;tex2html_html_special_mark_quot;(.)/\1/g;
    $str =~ s/\012/;tex2html_html_special_mark_quot;/g;
    $str =~ s/\011/\\\\/g;

    local($key_part, $pageref) = split("\003", $str, 2);
    local(@keys) = split("\001", $key_part);
#print STDERR "\nINDEX ($str)($key_part, $pageref)(@keys)\n";
    # If TITLE is not yet available (i.e the \index command is in the title of the
    # current section), use $before.
    $TITLE = $before unless $TITLE;
    # Save the reference
    local($words) = (&get_first_words($TITLE, 4) || 'no title');
    local($super_key) = '';
    local($sort_key, $printable_key, $cur_key);
    foreach $key (@keys) {
        ($sort_key, $printable_key) = split("\002", $key);
        $sort_key .= "@$printable_key" if $printable_key;
        $sort_key =~ tr/A-Z/a-z/;
        if ($super_key) {
            $cur_key = $super_key . "\001" . $sort_key;
            $sub_index{$super_key} .= $cur_key . "\004";
        } else {
            $cur_key = $sort_key;
        }
        $index{$super_key} .= "";
        $printable_key{$cur_key} = $printable_key || $key;
        $super_key .= $cur_key;
    }
    if ($pageref) {
        $index{$cur_key} .= $pageref . ", ";
    } else {
        $index{$cur_key} .= &make_href("$CURRENT_FILE#$br_id",$words) . ", ";
    } 
    join('',"<A NAME=$br_id>$anchor_invisible_mark<\/A>",$_);
}

1;				# This must be the last line
