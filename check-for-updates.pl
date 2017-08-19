#!/usr/bin/env perl

use autodie;
use strict;
use warnings;
use feature qw(say);
use experimental 'signatures';

use FindBin;
use File::Spec;
use List::Util qw(min);
use Mojo::UserAgent;

use Data::Printer;

my $ua = Mojo::UserAgent->new;

sub github_version_checker($url) {
    my ( $user, $repo ) = $url =~ m{github[.]com/([^/]+)/([^/]+)};
    my $repo_data = $ua->get("https://api.github.com/repos/$user/$repo")->res->json;
    my $default_branch = $repo_data->{'default_branch'};
    my $branch_data = $ua->get("https://api.github.com/repos/$user/$repo/git/refs/heads/$default_branch")->res->json;
    return $branch_data->{'object'}{'sha'};
}

sub drchip_version_checker($full_url) {
    my ( $url, $fragment ) = $full_url =~ /^(.*)#(.*)$/;

    my $dom = $ua->get($url)->res->dom;

    my $version_table = $dom->find("a[name=$fragment]")->first->next;
    my $version_info = $version_table->all_text;
    unless($version_info =~ /Updated.*\(v([^)]+)\)/) {
        die "'$version_info' doesn't appear to contain versioning information!";
    }

    return $1;
}

sub vim_org_scripts_version_checker($url) {
    my $dom = $ua->get($url)->res->dom;

    my $package_header = $dom->find('table > tr.tableheader th')->grep(sub($th) {
        $th->text eq 'package'
    })->first;
    my $release_history_table = $package_header->ancestors('table')->first;
    return $release_history_table->find('tr:not(.tableheader) td:nth-child(2)')->first->all_text;
}

sub get_version_checker($url) {
    if($url =~ /github[.]com/) {
        return \&github_version_checker;
    } elsif($url =~ /drchip[.]org/) {
        return \&drchip_version_checker;
    } elsif($url =~ m{www[.]vim[.]org/scripts}) {
        return \&vim_org_scripts_version_checker;
    }
    die "I don't know how to handle $url";
}

sub git_sha_comparator($lhs, $rhs) {
    my $prefix_length = min(length($lhs), length($rhs));

    return substr($lhs, 0, $prefix_length) eq substr($rhs, 0, $prefix_length);
}

sub full_string_comparator($lhs, $rhs) {
    return $lhs eq $rhs;
}

sub get_version_comparator($url) {
    if($url =~ /github[.]com/) {
        return \&git_sha_comparator;
    } elsif($url =~ /drchip[.]org/) {
        return \&full_string_comparator;
    } elsif($url =~ m{www[.]vim[.]org/scripts}) {
        return \&full_string_comparator;
    }
    die "I don't know how to handle $url";
}

my @plugins_to_check;

open my $pipe, '-|', 'git', 'ls-files', File::Spec->catdir($FindBin::Bin, 'bundle');
my $current_plugin = '';
while(<$pipe>) {
    chomp;

    if(m{^(bundle/([^/]+))}) {
        my ( $plugin_path, $plugin_name ) = ( $1, $2 );
        next if $current_plugin eq $plugin_name;
        $current_plugin = $plugin_name;
        $plugin_path = File::Spec->catdir($FindBin::Bin, $plugin_path);
        my $upstream_path = File::Spec->catfile($plugin_path, '.upstream');
        unless(-e $upstream_path) {
            die "No .upstream file for $plugin_name; exiting\n";
        }
        open my $fh, '<', $upstream_path;
        my $line = <$fh>;
        close $fh;
        next unless defined $line; # my own plugin, managed here
        chomp $line;
        my ( $upstream_url, $version ) = split /\s+/, $line;
        push @plugins_to_check, [ $plugin_path, $plugin_name, $upstream_url, $version ];
    } else {
        die "'$_' doesn't match my plugin regex";
    }
}
close $pipe;

for my $plugin (@plugins_to_check) {
    my ( $path, $name, $upstream, $version ) = @$plugin;

    my $version_checker = get_version_checker($upstream);
    my $version_cmp = get_version_comparator($upstream);

    my $upstream_version = $version_checker->($upstream);

    if(!$version_cmp->($upstream_version, $version)) {
        say "$name is out of date (us: $version upstream: $upstream_version)";
    }
}
