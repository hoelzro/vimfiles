#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);
use experimental qw(signatures);


my $YAML_IDENTIFIER = qr/\w/;

die "usage: $0 [line] [column]\n" unless @ARGV >= 2;

my $line_no = shift @ARGV;
my $column = shift @ARGV;

my @previous_lines;

while(<>) {
    chomp;

    if($line_no == $.) {
        my $before = substr $_, 0, $column;
        my $after = substr $_, $column;
        my $prefix;
        ( $prefix, $before ) = $before =~ /^(.*?)($YAML_IDENTIFIER+)$/;
        ( $after )  = $after  =~ /^($YAML_IDENTIFIER+)/;
        my $ident_under_cursor = $before . $after;

        die "assumption: cursor is over YAML dictionary key" if $prefix =~ /$YAML_IDENTIFIER/;

        @previous_lines = reverse @previous_lines;

        my $current_indent = length($prefix);

        my @path_components = ($ident_under_cursor);

        for my $preceding_line (@previous_lines) {
            my ( $indent, $key ) = $preceding_line =~ /^(\s*(?:[-]\s*)?)($YAML_IDENTIFIER+)/;

            $indent = length($indent);

            if($indent < $current_indent) {
                push @path_components, $key;
                $current_indent = $indent;
            }
        }

        say join('.', reverse @path_components);

        last;
    } else {
        push @previous_lines, $_;
    }
}
