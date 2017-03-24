use File::Find;
use Data::Dumper;

my $currdir;
my $counter = 0;

sub eachFile {
  my $filename = $_;
  my $fullpath = $File::Find::name;
  if (-e $filename && (($filename =~ '\.java$') || ($filename =~ '\.py') ||
         ($filename =~ '\.cs$') || ($filename =~ '\.pl') || ($filename =~ '\.js'))) { 
      #warn "processing $File::Find::name" ; 
      my $err = `cp $fullpath $currdir 2>&1 1>/dev/null`;
  }
}

my $dirs = {};
find({wanted => \&dir_names, no_chdir => 1}, ".");
sub dir_names {
    if ((-f $File::Find::dir, '/') && !($File::Find::dir =~ 'env') 
        && !($File::Find::dir =~ '^\.$') && !($File::Find::dir =~ 'git')
        && !($File::Find::dir =~ 'idea') && !($File::Find::dir =~ /\/(.*)\//)) {
        return if $dirs->{$File::Find::dir};
        $currdir = $File::Find::dir;
        $dirs->{$File::Find::dir} = 1;
        $counter = 0;
        warn "processing $File::Find::dir";
        find({wanted => \&eachFile, no_chdir => 1}, $File::Find::dir);
    }
}
