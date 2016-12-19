package Test::Style::BaseLib;

use lib 'lib';
use lib 'inc';

use Test::Base -Base;

use Test::Style::Util;

use File::Temp qw( tempfile );
use IPC::Run ();

use Data::Dumper;
use base 'Exporter';

our @EXPORT = qw(
    run_test
);


sub parse_cmd ($) {
    my $cmd = shift;
    my @cmd;
    while (1) {
        if ($cmd =~ /\G\s*"(.*?)"/gmsc) {
            push @cmd, $1;

        } elsif ($cmd =~ /\G\s*'(.*?)'/gmsc) {
            push @cmd, $1;

        } elsif ($cmd =~ /\G\s*(\S+)/gmsc) {
            push @cmd, $1;

        } else {
            last;
        }
    }

    return @cmd;
}

sub run_test(){
    for my $block (Test::Base::blocks()) {
        run_block($block);
    } 
}

sub run_block($) {

    
    my $block = shift;
    my $timeout = $block->timeout || 10;
    
    my $interpreter = $block->interpreter; 
    
    my $program = $block->program;
    
    my $cmd = "$interpreter $program";
    
    if (defined $block->code) {
        my ($out, $luafile) = tempfile("testXXXXXX",
                                        SUFFIX => '.lua',
                                        TMPDIR => 1,
                                        UNLINK => 1);
        print $out ($block->code);
        close $out;
        $cmd .= " $luafile";
    }
    
    my $name = $block->name;
    my $config = $block->config;
    
    # print Dumper($block->code);
    
    # print Dumper($block->verify)
    
    my ($out, $err);
    my @cmd = parse_cmd($cmd);

    eval {
        IPC::Run::run(\@cmd, \undef, \$out, \$err,
                        IPC::Run::timeout($timeout));
    };

    # print $out;
    if ($out =~ /ALL SUCCESS/) {
        $out = "validation passed";
    }
    # if (defined $block->verify) {
    #     is $out, $block->verify, "$name - stdout eq okay";
    # }

    is $out, "validation passed", "$name - stdout eq okay";
}



1;

__END__

none
