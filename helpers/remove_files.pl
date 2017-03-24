use File::Find;

my $currdir;

sub eachFile {
  my $filename = $_;
  my $fullpath = $File::Find::name;
  if (-e $filename && 
          (($filename =~ '\.jar$') || ($filename =~ '\.xml$') || 
           ($filename =~ 'settings.py$') || ($filename =~ '__init__.py$') ||
           ($filename =~ 'manage.py$') || ($filename =~ 'wsgi.py$') ||
           ($filename =~ 'urls.py$'))) {
      warn "processing $File::Find::name" ;
      `rm $fullpath`;
  }
}

find({wanted => \&dir_names, no_chdir => 1}, ".");

sub dir_names {
    if (-f $File::Find::dir, '/' && !($File::Find::dir =~ 'env')
        && !($File::Find::dir =~ '^\.$')) {
        warn "processing $File::Find::dir";
        $currdir = $File::Find::dir;
        find({wanted => \&eachFile, no_chdir => 1}, $File::Find::dir);
    }
}    
