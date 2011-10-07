if exists('g:loaded_perl_module_completion') || !has('perl')
    finish
endif

let g:loaded_perl_module_completion = 1

function s:ReadMinicpanPathFromRcFile(rcFile)
    for line in readfile(a:rcFile)
        let matches = matchlist(line, '\v^local:\s*(.+)')
        if !empty(matches)
            return matches[1]
        endif
    endfor
    return ''
endfunction

if !exists('g:minicpan_path')
    if exists('$CPAN_MINI_CONFIG')
        let g:minicpan_path = s:ReadMinicpanPathFromRcFile($CPAN_MINI_CONFIG)
    else
        let g:minicpan_path = s:ReadMinicpanPathFromRcFile(expand('~') . '/.minicpanrc')
    end
endif

if !empty(g:minicpan_path)
  perl <<PERL

use lib VIM::Eval('expand("~")') . '/.vim/perl-lib/lib/perl5';
use local::lib VIM::Eval('expand("~")') . '/.vim/perl-lib';
require CPAN::Mini::Index;
our $index = CPAN::Mini::Index->new(
    minicpan_path => scalar(VIM::Eval('g:minicpan_path')),
    db_path       => VIM::Eval('expand("~")') . '/.vim/.perl-modules.db',
);
PERL

  function CompletePerlModules(ArgLead, CmdLine, CursorPos)
    let matches = []

    perl <<PERL
my $matches = $index->get_matches(scalar(VIM::Eval('a:ArgLead')));
foreach my $match (@$matches) {
    $match =~ s/'/''/g;
    VIM::Eval("add(matches, '$match')");
}
PERL

    return matches
  endfunction
endif
