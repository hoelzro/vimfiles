#!/bin/bash

exec /usr/bin/perl $(which cpanm) -l ~/.vim/perl-lib DBI DBD::SQLite Class::Accessor::Fast namespace::clean local::lib
