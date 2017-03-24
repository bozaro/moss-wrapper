use File::Find;
use Data::Dumper;

my $extentions = {
    python => 'py',
    java => 'java',
    nodejs => 'js',
    go => 'go',
    c_sharp => 'cs',
};

my ($language) = @ARGV;
my $extention = $extentions->{$language};
my $dirs = {};

find({wanted => \&dir_names, no_chdir => 1}, "./projects/$language/");
warn join(' ', keys %$dirs);
my $pairs = generate_pairs(keys %$dirs);
for my $pair (@$pairs) {
    compare_pair($pair);
}

sub compare_pair {
    my ($pair) = @_;
    warn "compairing pair $pair->[0] vs $pair->[1]";
    `perl moss.pl -l $language -d $pair->[0]/*.$extention $pair->[1]/*.$extention`;
}

sub dir_names {
    if ((-d $File::Find::dir) && !($File::Find::dir =~ 'env')
        && !($File::Find::dir =~ '^\.$') && !($File::Find::dir =~ 'git')
        && !($File::Find::dir =~ 'idea') && !($File::Find::dir =~ /\/(.*)\/(.*)\/(.*)\//)) {
        $dirs->{$File::Find::dir} = 1;
    }
}


sub generate_pairs {
    my @array = @_;
    my $pairs = [];
    for my $i ( 0 .. $#array ) {
        my $first = $array[$i];
        for my $j ( $i + 1 .. $#array ) {
            push @$pairs, [$first, $array[$j]];
        }
    }
    return $pairs;
}
