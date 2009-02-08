package Override;


use Exporter ();
use Cwd;
@ISA = qw(Exporter);
@EXPORT_OK = qw($DEBUG getpwuid link setenv getenv symlink rename
		make_directory_absolute unlink $dd $envkey $image_pre); 

$OS = $^O;                      # MSWin32, linux, OS/2 (or Warp? don't
                                # know)

if ($OS =~ os2) {
    $envkey = ';';
    $dd = '/';
    $image_pre = ''; # protect against long file-names
} elsif ($OS =~ macOS) {
    $envkey = '|';
    $dd = ':';
#} elsif ($OS =~ VMS) {
#    $envkey = '???';
#    $dd = '.';
} else {
    $envkey = ':';
    $dd = '/';
}


# Add your function here, add it to @EXPORT_OK and change the list in
# use Override in the scripts.

sub getpwuid {
  if ($OS =~ os2) {
    my $uid = shift;
    my ($username, $passwd, $gid, $realname, $home, $shell, $age, $comment);
    $username = $ENV{USER};
    $passwd = "XXXXX";
    $uid = 9999; # not used with os2 
    $gid = 8888; # not used with os2
    $age = "not used";
    $comment = "no comment";
    $realname =  $ENV{USERFULLNAME};
    $home = $ENV{HOME};
    $shell = $ENV{SHELL};
    return ($username, $password, $uid, $gid, $age, $comment, $realname, $home, $shell);
  } else {
    CORE::getpwuid(@_);
  }
}
                 
sub link {
    local ($from, $to) = @_;
    if ($OS =~ os2) {
	system("cp", $from, $to);
    } else {
	CORE::link($from,$to) ;
    }
}  

sub symlink {
    local ($to, $from) = @_;
    if ($OS =~ os2) {
	# No symlinks, so copy
	system("cp", $to, $from);
    }
    else {
	CORE::symlink($to,$from)
	}
}


sub getenv($) {
  my $envkey = shift;
  if ($OS =~ os2) {
      defined($ENV{$envkey}) ? split (";", $ENV{$envkey}) : undef;
  } else {	
    defined($ENV{$envkey}) ? split (":", $ENV{$envkey}) : undef;
  }
}

sub setenv($@) {
  my $envkey = shift;
  if ($OS = ~ os2) {
      $ENV{$envkey} = join(";", @_);
  } else {
    $ENV{$envkey} = join(":", @_);
  }
}

# perl uses os2 rename which will complain about existing files, files
# in use and so forth, therefore we use 'cp' instead.
# Note that in many cases unlink fails. The old files must than be deleted 
# manually after l2h finishes.
sub rename {
    my ($from,$to) = @_;
    if ($OS =~ os2) {
	system("cp", $from, $to);
	system("rm", $from);
    } else {
	CORE::rename($from,$to) ;
    }
}  

sub unlink {
    my ($from) = @_;
    if ($OS =~ os2) {
	system("rm", $from);
    } else {
	CORE::unlink($from) ;
    }
}  

# Given a directory name in either relative or absolute form, returns
# the absolute form.
# Note: The argument *must* be a directory name.
sub make_directory_absolute {
    local($path) = @_;
    local($orig_cwd);
    if ($OS =~ os2) {
	printf("Yes this is os2, path = %c \n", $path);
	if (!($path =~ /[a-zA-Z]:/)) {   # if $path doesn't start  with 'x:'
	    printf("path does not match \n");
	    $orig_cwd = getcwd;
	    chdir $path;
	    $path = getcwd;
	    chdir $orig_cwd;
	}
    } else {
	if (! ($path =~ /^$dd/)) {   # if $path doesn't start with '/'
	    $orig_cwd = &getcwd;
	    chdir $path;
	    $path = &getcwd;
	    chdir $orig_cwd;
	}
    }
    $path;
}


1;








