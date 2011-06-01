#!/bin/bash

for dir in $(find . -type d -name doc); do
    cd $dir
    vim -c 'helptags .' -c 'quit' -u NONE
    cd $OLDPWD
done
