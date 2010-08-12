#!/usr/bin/env perl

use 5.12.0;
use autodie qw(open opendir);
use warnings;

use AnyEvent;
use AnyEvent::HTTP qw(http_get);
use Hash::AsObject;

my @plugins;
my %plugin_set;
my $condvar = AnyEvent->condvar;
my $plugins_to_check;
my %watchers;

my $fh;
open $fh, '<', 'plugins';
while(<$fh>) {
    chomp;
    my ( $plugin, $version, $type, $source ) = split /:/, $_, 4;

    push @plugins, Hash::AsObject->new({
        name => $plugin,
        version => $version,
        type => $type,
        source => $source,
    });
    $plugin_set{$plugin} = 1;
}
close $fh;

my $dir;
opendir $dir, 'bundle';
while(my $name = readdir $dir) {
    next if $name =~ /^\./;
    unless(exists $plugin_set{$name}) {
        say "$name not found in plugins file!";
    }
}
closedir $dir;

$plugins_to_check = @plugins;

sub end_loop_if_done {
    unless(--$plugins_to_check) {
        $condvar->broadcast;
    }
}

sub check_me {
    end_loop_if_done;
}

sub check_vimscript {
    my ( $script_id ) = @_;
    http_get "http://www.vim.org/scripts/script.php?script_id=$script_id", sub {
        my ( $data ) = @_;
        end_loop_if_done;
    };
}

foreach my $plugin (@plugins) {
    my $type = $plugin->type;
    my $checker = __PACKAGE__->can('check_' . $type);
    unless($checker) {
        say "Unknown source type '$type'";
        $plugins_to_check--;
        next;
    }
    $checker->($plugin->source);
}

$condvar->wait;

__DATA__
- verbose option (prints what was found)
