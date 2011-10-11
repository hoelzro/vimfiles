#!/bin/bash

PERL=/usr/bin/perl

if [[ ! -z "$PATH_WITHOUT_PERLBREW" ]]; then
    PERL=$(PATH=$PATH_WITHOUT_PERLBREW which perl)
fi

exec $PERL $(which cpanm) -l ~/.vim/perl-lib DBI DBD::SQLite Class::Accessor::Fast namespace::clean local::lib List::MoreUtils Params::Util Sub::Install
