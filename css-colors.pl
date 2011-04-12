#!/usr/bin/env perl

use strict;
use warnings;

use List::MoreUtils qw(natatime);
use Template;

# begin colors {{{
my @named_colors = (
    # W3C colors
    maroon => 0x800000,
    red => 0xff0000,
    orange => 0xffA500,
    yellow => 0xffff00,
    olive => 0x808000,
    purple => 0x800080,
    fuchsia => 0xff00ff,
    white => 0xffffff,
    lime => 0x00ff00,
    green => 0x008000,
    navy => 0x000080,
    blue => 0x0000ff,
    aqua => 0x00ffff,
    teal => 0x008080,
    black => 0x000000,
    silver => 0xc0c0c0,
    gray => 0x808080,

    # Extra colors
    AliceBlue => 0xF0F8FF,
    AntiqueWhite => 0xFAEBD7,
    Aquamarine => 0x7FFFD4,
    Azure => 0xF0FFFF,
    Beige => 0xF5F5DC,
    Bisque => 0xFFE4C4,
    BlanchedAlmond => 0xFFEBCD,
    BlueViolet => 0x8A2BE2,
    Brown => 0xA52A2A,
    BurlyWood => 0xDEB887,
    CadetBlue => 0x5F9EA0,
    Chartreuse => 0x7FFF00,
    Chocolate => 0xD2691E,
    Coral => 0xFF7F50,
    CornflowerBlue => 0x6495ED,
    Cornsilk => 0xFFF8DC,
    Crimson => 0xDC143C,
    Cyan => 0x00FFFF,
    DarkBlue => 0x00008B,
    DarkCyan => 0x008B8B,
    DarkGoldenRod => 0xB8860B,
    DarkGray => 0xA9A9A9,
    DarkGrey => 0xA9A9A9,
    DarkGreen => 0x006400,
    DarkKhaki => 0xBDB76B,
    DarkMagenta => 0x8B008B,
    DarkOliveGreen => 0x556B2F,
    Darkorange => 0xFF8C00,
    DarkOrchid => 0x9932CC,
    DarkRed => 0x8B0000,
    DarkSalmon => 0xE9967A,
    DarkSeaGreen => 0x8FBC8F,
    DarkSlateBlue => 0x483D8B,
    DarkSlateGray => 0x2F4F4F,
    DarkSlateGrey => 0x2F4F4F,
    DarkTurquoise => 0x00CED1,
    DarkViolet => 0x9400D3,
    DeepPink => 0xFF1493,
    DeepSkyBlue => 0x00BFFF,
    DimGray => 0x696969,
    DimGrey => 0x696969,
    DodgerBlue => 0x1E90FF,
    FireBrick => 0xB22222,
    FloralWhite => 0xFFFAF0,
    ForestGreen => 0x228B22,
    Gainsboro => 0xDCDCDC,
    GhostWhite => 0xF8F8FF,
    Gold => 0xFFD700,
    GoldenRod => 0xDAA520,
    Grey => 0x808080,
    GreenYellow => 0xADFF2F,
    HoneyDew => 0xF0FFF0,
    HotPink => 0xFF69B4,
    IndianRed => 0xCD5C5C,
    Indigo => 0x4B0082,
    Ivory => 0xFFFFF0,
    Khaki => 0xF0E68C,
    Lavender => 0xE6E6FA,
    LavenderBlush => 0xFFF0F5,
    LawnGreen => 0x7CFC00,
    LemonChiffon => 0xFFFACD,
    LightBlue => 0xADD8E6,
    LightCoral => 0xF08080,
    LightCyan => 0xE0FFFF,
    LightGoldenRodYellow => 0xFAFAD2,
    LightGray => 0xD3D3D3,
    LightGrey => 0xD3D3D3,
    LightGreen => 0x90EE90,
    LightPink => 0xFFB6C1,
    LightSalmon => 0xFFA07A,
    LightSeaGreen => 0x20B2AA,
    LightSkyBlue => 0x87CEFA,
    LightSlateGray => 0x778899,
    LightSlateGrey => 0x778899,
    LightSteelBlue => 0xB0C4DE,
    LightYellow => 0xFFFFE0,
    LimeGreen => 0x32CD32,
    Linen => 0xFAF0E6,
    Magenta => 0xFF00FF,
    MediumAquaMarine => 0x66CDAA,
    MediumBlue => 0x0000CD,
    MediumOrchid => 0xBA55D3,
    MediumPurple => 0x9370D8,
    MediumSeaGreen => 0x3CB371,
    MediumSlateBlue => 0x7B68EE,
    MediumSpringGreen => 0x00FA9A,
    MediumTurquoise => 0x48D1CC,
    MediumVioletRed => 0xC71585,
    MidnightBlue => 0x191970,
    MintCream => 0xF5FFFA,
    MistyRose => 0xFFE4E1,
    Moccasin => 0xFFE4B5,
    NavajoWhite => 0xFFDEAD,
    OldLace => 0xFDF5E6,
    OliveDrab => 0x6B8E23,
    OrangeRed => 0xFF4500,
    Orchid => 0xDA70D6,
    PaleGoldenRod => 0xEEE8AA,
    PaleGreen => 0x98FB98,
    PaleTurquoise => 0xAFEEEE,
    PaleVioletRed => 0xD87093,
    PapayaWhip => 0xFFEFD5,
    PeachPuff => 0xFFDAB9,
    Peru => 0xCD853F,
    Pink => 0xFFC0CB,
    Plum => 0xDDA0DD,
    PowderBlue => 0xB0E0E6,
    RosyBrown => 0xBC8F8F,
    RoyalBlue => 0x4169E1,
    SaddleBrown => 0x8B4513,
    Salmon => 0xFA8072,
    SandyBrown => 0xF4A460,
    SeaGreen => 0x2E8B57,
    SeaShell => 0xFFF5EE,
    Sienna => 0xA0522D,
    SkyBlue => 0x87CEEB,
    SlateBlue => 0x6A5ACD,
    SlateGray => 0x708090,
    SlateGrey => 0x708090,
    Snow => 0xFFFAFA,
    SpringGreen => 0x00FF7F,
    SteelBlue => 0x4682B4,
    Tan => 0xD2B48C,
    Thistle => 0xD8BFD8,
    Tomato => 0xFF6347,
    Turquoise => 0x40E0D0,
    Violet => 0xEE82EE,
    Wheat => 0xF5DEB3,
    WhiteSmoke => 0xF5F5F5,
    YellowGreen => 0x9ACD32,
);
# end colors }}}

my $it = natatime 2, @named_colors;
my @color_hashes;

while(my ( $name, $value ) = $it->()) {
    push @color_hashes, {
        name  => $name,
        value => $value,
    }
}

my $perl = <<'PERL';
my @basic = (
    [ 0xCD, 0x00, 0x00 ],
    [ 0x00, 0xCD, 0x00 ],
    [ 0xCD, 0xCD, 0x00 ],
    [ 0x00, 0x00, 0xEE ],
    [ 0xCD, 0x00, 0xCD ],
    [ 0x00, 0xCD, 0xCD ],
    [ 0xE5, 0xE5, 0xE5 ],
    [ 0x7F, 0x7F, 0x7F ],
    [ 0xFF, 0x00, 0x00 ],
    [ 0x00, 0xFF, 0x00 ],
    [ 0xFF, 0xFF, 0x00 ],
    [ 0x5C, 0x5C, 0xFF ],
    [ 0xFF, 0x00, 0xFF ],
    [ 0x00, 0xFF, 0xFF ],
);

sub round {
    my ( $n ) = @_;

    my $int = int($n);
    if($n - $int >= 0.5) {
        return $int + 1;
    } else {
        return $int;
    }
}

sub fg_for_bg {
    my ( $bg ) = @_;

    my $red   = ($bg >> 16) & 0xff;
    my $green = ($bg >> 8) & 0xff;
    my $blue  = $bg & 0xff;

    if($red * 30 + $green * 59 + $blue * 11 > 12000) {
        return 0x000000;
    } else {
        return 0xffffff;
    }
}

sub rgb_to_xterm {
    my ( $rgb ) = @_;

    my $blue  = $rgb & 0xff;
    my $green = ($rgb >> 8) & 0xff;
    my $red   = ($rgb >> 16) & 0xff;

    my $closest_basic = 1;
    my $basic_distance = sqrt(($basic[0][0] - $red)   ** 2 +
                              ($basic[0][1] - $green) ** 2 +
                              ($basic[0][2] - $blue)  ** 2);
    for(my $i = 1; $i < @basic; $i++) {
        my $distance = sqrt(($basic[$i][0] - $red)   ** 2 +
                            ($basic[$i][1] - $green) ** 2 +
                            ($basic[$i][2] - $blue)  ** 2);
        if($distance < $basic_distance) {
            $basic_distance = $distance;
            $closest_basic  = $i + 1;
        }
    }

    my $r = $red   - 55;
    my $g = $green - 55;
    my $b = $blue  - 55;

    my $cube_red   = round(($r < 0 ? 0 : $r) / 40);
    my $cube_green = round(($g < 0 ? 0 : $g) / 40);
    my $cube_blue  = round(($b < 0 ? 0 : $b) / 40);

    my $cube_distance = sqrt((($cube_red   * 40 + ($r < 0 ? 55 + $r : 55)) - $red)   ** 2 +
                             (($cube_green * 40 + ($g < 0 ? 55 + $g : 55)) - $green) ** 2 +
                             (($cube_blue  * 40 + ($b < 0 ? 55 + $b : 55)) - $blue)  ** 2);

    my $gray_red   = round(($red   - -2) / 10);
    my $gray_green = round(($green - -2) / 10);
    my $gray_blue  = round(($blue  - -2) / 10);

    if($gray_red == $gray_green && $gray_green == $gray_blue) {
        my $gray_distance = sqrt((($gray_red   * 10 + -2) - $red)   ** 2 +
                                 (($gray_green * 10 + -2) - $green) ** 2 +
                                 (($gray_blue  * 10 + -2) - $blue)  ** 2);

        if($gray_distance < $cube_distance) {
            if($gray_distance < $basic_distance) {
                return $gray_red + 231;
            } else {
                return $closest_basic;
            }
        } else {
            if($cube_distance < $basic_distance) {
                return $cube_red * 36 + $cube_green * 6 + $cube_blue + 16;
            } else {
                return $closest_basic;
            }
        }
    } else {
        if($cube_distance < $basic_distance) {
            return $cube_red * 36 + $cube_green * 6 + $cube_blue + 16;
        } else {
            return $closest_basic;
        }
    }
}
PERL

eval $perl;

my %stash = (
    named_colors => \@color_hashes,
    fg_for_bg    => \&fg_for_bg,
    rgb_to_xterm => \&rgb_to_xterm,
    to_hex       => sub { sprintf('%x', $_[0]) },
    perl         => $perl,
);

my $tt = Template->new({});

my $output = '';
$tt->process(\*DATA, \%stash, $output) || die $tt->error;

print $output;

__DATA__
" Language:	   Colored CSS Color Preview
" Maintainer:	Niklas Hofer <niklas+vim@lanpartei.de>
" URL:		   svn://lanpartei.de/vimrc/after/syntax/css.vim
" Last Change:	2008 Feb 12
" Licence:     No Warranties. Do whatever you want with this. But please tell me!
" Version:     0.6

" This file wasn't actually written by Niklas!  But its contents are generated
" by a Perl script that is based on his css.vim.

perl <<PERL
use strict;

[% perl -%]
PERL

function! s:SetMatcher(clr,pat)
   let clr = ('0x' . substitute(a:clr, '^#', '', '')) + 0
   let group = 'cssColor'.substitute(a:clr,'^#','','')
   redir => s:currentmatch
      silent! exe 'syn list '.group
   redir END
   if s:currentmatch !~ a:pat.'\/'
      exe 'syn match '.group.' /'.a:pat.'\>/ contained'
      exe 'syn cluster cssColors add='.group
      perl <<PERL
    my $group = VIM::Eval('group');
    my $clr   = VIM::Eval('clr');
    VIM::DoCommand("hi $group ctermfg=" . rgb_to_xterm(fg_for_bg($clr)));
    VIM::DoCommand("hi $group ctermbg=" . rgb_to_xterm($clr));
PERL
      return 1
   else
      return 0
   endif
endfunction

function! s:PreviewCSSColorInLine(where)
   " TODO use cssColor matchdata
   let foundcolor = matchstr( getline(a:where), '#[0-9A-Fa-f]\{3,6\}\>' )
   let color = ''
   if foundcolor != ''
      if foundcolor =~ '#\x\{6}$'
         let color = foundcolor
      elseif foundcolor =~ '#\x\{3}$'
         let color = substitute(foundcolor, '\(\x\)\(\x\)\(\x\)', '\1\1\2\2\3\3', '')
      else
         let color = ''
      endif
      if color != ''
         return s:SetMatcher(color,foundcolor)
      else
         return 0
      endif
   else
      return 0
   endif
endfunction

if has("gui_running") || &t_Co==256
   " HACK modify cssDefinition to add @cssColors to its contains
   redir => s:olddef
      silent!  syn list cssDefinition
   redir END
   if s:olddef != ''
      let s:b = strridx(s:olddef,'matchgroup')
      if s:b != -1
         exe 'syn region cssDefinition '.strpart(s:olddef,s:b).',@cssColors'
      endif
   endif

   [% FOREACH color = named_colors -%]
    [% SET group = 'cssColor' _ to_hex(color.value) %]

    syn keyword [% group -%] [% color.name -%] contained
    syn cluster cssColors add=[% group %]
    hi [% group -%] ctermfg=[% rgb_to_xterm(fg_for_bg(color.value)) %]
    hi [% group -%] ctermbg=[% rgb_to_xterm(color.value) %]
   [% END -%]

   let i = 1
   while i <= line("$")
      call s:PreviewCSSColorInLine(i)
      let i = i+1
   endwhile
   unlet i

   autocmd CursorHold * silent call s:PreviewCSSColorInLine('.')
   autocmd CursorHoldI * silent call s:PreviewCSSColorInLine('.')
   set ut=100
endif		" has("gui_running")
