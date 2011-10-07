package CPAN::Mini::Index;

use strict;
use warnings;
use parent 'Class::Accessor::Fast';

use Carp qw(croak);
use DBI;
use File::Spec;
use IO::Uncompress::Gunzip;

use namespace::clean;

__PACKAGE__->mk_accessors(qw/minicpan_path db_path dbh min_query_len/);

sub new {
    my ( $class, %opts ) = @_;

    croak "db_path required"       unless defined $opts{'db_path'};
    croak "minicpan_path required" unless defined $opts{'minicpan_path'};
    $opts{'min_query_len'} //= 3;

    return bless \%opts, $class;
}

sub get_matches {
    my ( $self, $prefix ) = @_;

    if(length($prefix) < $self->min_query_len) {
        return [];
    }

    my $dbh = $self->dbh;
    unless($dbh) {
        $self->_connect;
        $dbh = $self->dbh;
    }

    return $dbh->selectcol_arrayref('SELECT name FROM modules WHERE name LIKE ?',
        undef, $prefix . '%');
}

sub _connect {
    my ( $self ) = @_;

    my $db_mtime       = (stat $self->db_path)[9];
    my $minicpan_mtime = (stat $self->minicpan_path)[9];

    my $dbh = DBI->connect('dbi:SQLite:dbname=' . $self->db_path, undef, undef, {
        RaiseError => 1,
        PrintError => 0,
    });

    $self->dbh($dbh);

    unless(defined $db_mtime) { # file doesn't exist
        $self->_init_db;
    }

    if(!defined($db_mtime) || $db_mtime < $minicpan_mtime) {
        $self->_populate_db;
    }
}

sub _init_db {
    my ( $self ) = @_;

    my $dbh = $self->dbh;

    $dbh->do(<<SQL);
CREATE TABLE modules (
    name TEXT NOT NULL PRIMARY KEY
)
SQL
}

sub _populate_db {
    my ( $self ) = @_;

    my $dbh = $self->dbh;
    my $sth = $dbh->prepare('INSERT INTO modules VALUES (?)');
    $dbh->begin_work;
    $dbh->do('DELETE FROM modules');

    my $z = IO::Uncompress::Gunzip->new($self->minicpan_path);

    while(<$z>) {
        chomp;

        if(/^\s*$/ .. 0) {
            unless(/^\s*$/) {
                my ( $module ) = split;
                $sth->execute($module);
            }
        }
    }

    close $z;
    $dbh->commit;
}

1;
