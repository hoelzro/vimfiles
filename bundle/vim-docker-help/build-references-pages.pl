#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);
use experimental qw(signatures);

# run against https://raw.githubusercontent.com/docker/cli/master/docs/reference/builder.md

sub flush_section($section_name, @lines) {
    my $filename = 'reference/' . lc($section_name) . '.txt';

    open my $pandoc_pipe, '|-', 'pandoc', '-t', 'plain', '-o', $filename;
    for my $line (@lines) {
        say {$pandoc_pipe} $line;
    }
    close $pandoc_pipe;
}

my $current_section_name;
my @current_section_lines;

mkdir 'reference';

while(<>) {
    chomp;

    if(/^\s*##\s+(?<section_name>[A-Z]+)\s*$/) {
        if($current_section_name) {
            flush_section($current_section_name, @current_section_lines);
        }
        $current_section_name = $+{'section_name'};
        @current_section_lines = ($_);
    } elsif($current_section_name) {
        push @current_section_lines, $_;
    }
}

if($current_section_name) {
    flush_section($current_section_name, @current_section_lines);
}
