function InsertTemplate(name)
    perl << PERL
    my ($ok, $name) = VIM::Eval("a:name");
    my $file = "/home/rhoelz/.vim/templates/$name";
    my $fh;
    if(open $fh, '<', $file) {
	my @lines = <$fh>;
	@lines = map { chomp; $_ } @lines;
	close $fh;
	my $first = shift @lines;
	$curbuf->Set(1, $first);
	$curbuf->Append(1, @lines);
    }
PERL
endfunction
