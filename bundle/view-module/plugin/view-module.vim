if has('perl')
    perl <<PERL
    eval {
        require Module::Finder;
        our $module_finder = Module::Finder->new(dirs => [grep { $_ ne '.' } @INC]);
        VIM::DoCommand("let g:has_module_finder = 1");
    };
    if($@) {
        VIM::DoCommand("let g:has_module_finder = 0");
    }
PERL

    if g:has_module_finder
        function ViewModule(modname)
            perl <<PERL
        my $modname = VIM::Eval('a:modname');
        my $info = $module_finder->module_info($modname);
        if($info) {
            VIM::DoCommand("edit " . $info->filename);
        } else {
            VIM::Msg("Module '$modname' not found");
        }
PERL
        endfunction

        function ListPerlModules(ArgLead, CmdLine, CursorPos)
            let completions = []
            perl <<PERL
        my $ArgLead = VIM::Eval('a:ArgLead');
        my $re = qr/^\Q$ArgLead\E/;
        my @modules = sort(grep { /$re/ } $module_finder->modules);
        foreach my $module (@modules) {
            VIM::Eval('add(l:completions, "' . $module . '")');
        }
PERL
            return completions
        endfunction

        command -nargs=1 -count=0 -complete=customlist,ListPerlModules ViewModule call ViewModule(<f-args>)
    else
        echoerr "The Perl module Module::Finder is required to use this plugin"
    endif
else
    echoerr "+perl is required for this plugin"
endif
