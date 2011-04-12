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

       

    syn keyword cssColor800000 maroon contained
    syn cluster cssColors add=cssColor800000
    hi cssColor800000 ctermfg=231
    hi cssColor800000 ctermbg=88
       

    syn keyword cssColorff0000 red contained
    syn cluster cssColors add=cssColorff0000
    hi cssColorff0000 ctermfg=231
    hi cssColorff0000 ctermbg=9
       

    syn keyword cssColorffa500 orange contained
    syn cluster cssColors add=cssColorffa500
    hi cssColorffa500 ctermfg=16
    hi cssColorffa500 ctermbg=214
       

    syn keyword cssColorffff00 yellow contained
    syn cluster cssColors add=cssColorffff00
    hi cssColorffff00 ctermfg=16
    hi cssColorffff00 ctermbg=11
       

    syn keyword cssColor808000 olive contained
    syn cluster cssColors add=cssColor808000
    hi cssColor808000 ctermfg=231
    hi cssColor808000 ctermbg=100
       

    syn keyword cssColor800080 purple contained
    syn cluster cssColors add=cssColor800080
    hi cssColor800080 ctermfg=231
    hi cssColor800080 ctermbg=90
       

    syn keyword cssColorff00ff fuchsia contained
    syn cluster cssColors add=cssColorff00ff
    hi cssColorff00ff ctermfg=231
    hi cssColorff00ff ctermbg=13
       

    syn keyword cssColorffffff white contained
    syn cluster cssColors add=cssColorffffff
    hi cssColorffffff ctermfg=16
    hi cssColorffffff ctermbg=231
       

    syn keyword cssColorff00 lime contained
    syn cluster cssColors add=cssColorff00
    hi cssColorff00 ctermfg=16
    hi cssColorff00 ctermbg=10
       

    syn keyword cssColor8000 green contained
    syn cluster cssColors add=cssColor8000
    hi cssColor8000 ctermfg=231
    hi cssColor8000 ctermbg=28
       

    syn keyword cssColor80 navy contained
    syn cluster cssColors add=cssColor80
    hi cssColor80 ctermfg=231
    hi cssColor80 ctermbg=18
       

    syn keyword cssColorff blue contained
    syn cluster cssColors add=cssColorff
    hi cssColorff ctermfg=231
    hi cssColorff ctermbg=21
       

    syn keyword cssColorffff aqua contained
    syn cluster cssColors add=cssColorffff
    hi cssColorffff ctermfg=16
    hi cssColorffff ctermbg=14
       

    syn keyword cssColor8080 teal contained
    syn cluster cssColors add=cssColor8080
    hi cssColor8080 ctermfg=231
    hi cssColor8080 ctermbg=30
       

    syn keyword cssColor0 black contained
    syn cluster cssColors add=cssColor0
    hi cssColor0 ctermfg=231
    hi cssColor0 ctermbg=16
       

    syn keyword cssColorc0c0c0 silver contained
    syn cluster cssColors add=cssColorc0c0c0
    hi cssColorc0c0c0 ctermfg=16
    hi cssColorc0c0c0 ctermbg=250
       

    syn keyword cssColor808080 gray contained
    syn cluster cssColors add=cssColor808080
    hi cssColor808080 ctermfg=16
    hi cssColor808080 ctermbg=244
       

    syn keyword cssColorf0f8ff AliceBlue contained
    syn cluster cssColors add=cssColorf0f8ff
    hi cssColorf0f8ff ctermfg=16
    hi cssColorf0f8ff ctermbg=231
       

    syn keyword cssColorfaebd7 AntiqueWhite contained
    syn cluster cssColors add=cssColorfaebd7
    hi cssColorfaebd7 ctermfg=16
    hi cssColorfaebd7 ctermbg=230
       

    syn keyword cssColor7fffd4 Aquamarine contained
    syn cluster cssColors add=cssColor7fffd4
    hi cssColor7fffd4 ctermfg=16
    hi cssColor7fffd4 ctermbg=122
       

    syn keyword cssColorf0ffff Azure contained
    syn cluster cssColors add=cssColorf0ffff
    hi cssColorf0ffff ctermfg=16
    hi cssColorf0ffff ctermbg=231
       

    syn keyword cssColorf5f5dc Beige contained
    syn cluster cssColors add=cssColorf5f5dc
    hi cssColorf5f5dc ctermfg=16
    hi cssColorf5f5dc ctermbg=230
       

    syn keyword cssColorffe4c4 Bisque contained
    syn cluster cssColors add=cssColorffe4c4
    hi cssColorffe4c4 ctermfg=16
    hi cssColorffe4c4 ctermbg=224
       

    syn keyword cssColorffebcd BlanchedAlmond contained
    syn cluster cssColors add=cssColorffebcd
    hi cssColorffebcd ctermfg=16
    hi cssColorffebcd ctermbg=230
       

    syn keyword cssColor8a2be2 BlueViolet contained
    syn cluster cssColors add=cssColor8a2be2
    hi cssColor8a2be2 ctermfg=231
    hi cssColor8a2be2 ctermbg=92
       

    syn keyword cssColora52a2a Brown contained
    syn cluster cssColors add=cssColora52a2a
    hi cssColora52a2a ctermfg=231
    hi cssColora52a2a ctermbg=124
       

    syn keyword cssColordeb887 BurlyWood contained
    syn cluster cssColors add=cssColordeb887
    hi cssColordeb887 ctermfg=16
    hi cssColordeb887 ctermbg=180
       

    syn keyword cssColor5f9ea0 CadetBlue contained
    syn cluster cssColors add=cssColor5f9ea0
    hi cssColor5f9ea0 ctermfg=16
    hi cssColor5f9ea0 ctermbg=73
       

    syn keyword cssColor7fff00 Chartreuse contained
    syn cluster cssColors add=cssColor7fff00
    hi cssColor7fff00 ctermfg=16
    hi cssColor7fff00 ctermbg=118
       

    syn keyword cssColord2691e Chocolate contained
    syn cluster cssColors add=cssColord2691e
    hi cssColord2691e ctermfg=16
    hi cssColord2691e ctermbg=166
       

    syn keyword cssColorff7f50 Coral contained
    syn cluster cssColors add=cssColorff7f50
    hi cssColorff7f50 ctermfg=16
    hi cssColorff7f50 ctermbg=209
       

    syn keyword cssColor6495ed CornflowerBlue contained
    syn cluster cssColors add=cssColor6495ed
    hi cssColor6495ed ctermfg=16
    hi cssColor6495ed ctermbg=69
       

    syn keyword cssColorfff8dc Cornsilk contained
    syn cluster cssColors add=cssColorfff8dc
    hi cssColorfff8dc ctermfg=16
    hi cssColorfff8dc ctermbg=230
       

    syn keyword cssColordc143c Crimson contained
    syn cluster cssColors add=cssColordc143c
    hi cssColordc143c ctermfg=231
    hi cssColordc143c ctermbg=160
       

    syn keyword cssColorffff Cyan contained
    syn cluster cssColors add=cssColorffff
    hi cssColorffff ctermfg=16
    hi cssColorffff ctermbg=14
       

    syn keyword cssColor8b DarkBlue contained
    syn cluster cssColors add=cssColor8b
    hi cssColor8b ctermfg=231
    hi cssColor8b ctermbg=18
       

    syn keyword cssColor8b8b DarkCyan contained
    syn cluster cssColors add=cssColor8b8b
    hi cssColor8b8b ctermfg=231
    hi cssColor8b8b ctermbg=30
       

    syn keyword cssColorb8860b DarkGoldenRod contained
    syn cluster cssColors add=cssColorb8860b
    hi cssColorb8860b ctermfg=16
    hi cssColorb8860b ctermbg=136
       

    syn keyword cssColora9a9a9 DarkGray contained
    syn cluster cssColors add=cssColora9a9a9
    hi cssColora9a9a9 ctermfg=16
    hi cssColora9a9a9 ctermbg=248
       

    syn keyword cssColora9a9a9 DarkGrey contained
    syn cluster cssColors add=cssColora9a9a9
    hi cssColora9a9a9 ctermfg=16
    hi cssColora9a9a9 ctermbg=248
       

    syn keyword cssColor6400 DarkGreen contained
    syn cluster cssColors add=cssColor6400
    hi cssColor6400 ctermfg=231
    hi cssColor6400 ctermbg=22
       

    syn keyword cssColorbdb76b DarkKhaki contained
    syn cluster cssColors add=cssColorbdb76b
    hi cssColorbdb76b ctermfg=16
    hi cssColorbdb76b ctermbg=143
       

    syn keyword cssColor8b008b DarkMagenta contained
    syn cluster cssColors add=cssColor8b008b
    hi cssColor8b008b ctermfg=231
    hi cssColor8b008b ctermbg=90
       

    syn keyword cssColor556b2f DarkOliveGreen contained
    syn cluster cssColors add=cssColor556b2f
    hi cssColor556b2f ctermfg=231
    hi cssColor556b2f ctermbg=58
       

    syn keyword cssColorff8c00 Darkorange contained
    syn cluster cssColors add=cssColorff8c00
    hi cssColorff8c00 ctermfg=16
    hi cssColorff8c00 ctermbg=208
       

    syn keyword cssColor9932cc DarkOrchid contained
    syn cluster cssColors add=cssColor9932cc
    hi cssColor9932cc ctermfg=231
    hi cssColor9932cc ctermbg=92
       

    syn keyword cssColor8b0000 DarkRed contained
    syn cluster cssColors add=cssColor8b0000
    hi cssColor8b0000 ctermfg=231
    hi cssColor8b0000 ctermbg=88
       

    syn keyword cssColore9967a DarkSalmon contained
    syn cluster cssColors add=cssColore9967a
    hi cssColore9967a ctermfg=16
    hi cssColore9967a ctermbg=174
       

    syn keyword cssColor8fbc8f DarkSeaGreen contained
    syn cluster cssColors add=cssColor8fbc8f
    hi cssColor8fbc8f ctermfg=16
    hi cssColor8fbc8f ctermbg=108
       

    syn keyword cssColor483d8b DarkSlateBlue contained
    syn cluster cssColors add=cssColor483d8b
    hi cssColor483d8b ctermfg=231
    hi cssColor483d8b ctermbg=18
       

    syn keyword cssColor2f4f4f DarkSlateGray contained
    syn cluster cssColors add=cssColor2f4f4f
    hi cssColor2f4f4f ctermfg=231
    hi cssColor2f4f4f ctermbg=23
       

    syn keyword cssColor2f4f4f DarkSlateGrey contained
    syn cluster cssColors add=cssColor2f4f4f
    hi cssColor2f4f4f ctermfg=231
    hi cssColor2f4f4f ctermbg=23
       

    syn keyword cssColorced1 DarkTurquoise contained
    syn cluster cssColors add=cssColorced1
    hi cssColorced1 ctermfg=16
    hi cssColorced1 ctermbg=6
       

    syn keyword cssColor9400d3 DarkViolet contained
    syn cluster cssColors add=cssColor9400d3
    hi cssColor9400d3 ctermfg=231
    hi cssColor9400d3 ctermbg=92
       

    syn keyword cssColorff1493 DeepPink contained
    syn cluster cssColors add=cssColorff1493
    hi cssColorff1493 ctermfg=231
    hi cssColorff1493 ctermbg=198
       

    syn keyword cssColorbfff DeepSkyBlue contained
    syn cluster cssColors add=cssColorbfff
    hi cssColorbfff ctermfg=16
    hi cssColorbfff ctermbg=39
       

    syn keyword cssColor696969 DimGray contained
    syn cluster cssColors add=cssColor696969
    hi cssColor696969 ctermfg=231
    hi cssColor696969 ctermbg=242
       

    syn keyword cssColor696969 DimGrey contained
    syn cluster cssColors add=cssColor696969
    hi cssColor696969 ctermfg=231
    hi cssColor696969 ctermbg=242
       

    syn keyword cssColor1e90ff DodgerBlue contained
    syn cluster cssColors add=cssColor1e90ff
    hi cssColor1e90ff ctermfg=16
    hi cssColor1e90ff ctermbg=33
       

    syn keyword cssColorb22222 FireBrick contained
    syn cluster cssColors add=cssColorb22222
    hi cssColorb22222 ctermfg=231
    hi cssColorb22222 ctermbg=124
       

    syn keyword cssColorfffaf0 FloralWhite contained
    syn cluster cssColors add=cssColorfffaf0
    hi cssColorfffaf0 ctermfg=16
    hi cssColorfffaf0 ctermbg=231
       

    syn keyword cssColor228b22 ForestGreen contained
    syn cluster cssColors add=cssColor228b22
    hi cssColor228b22 ctermfg=231
    hi cssColor228b22 ctermbg=28
       

    syn keyword cssColordcdcdc Gainsboro contained
    syn cluster cssColors add=cssColordcdcdc
    hi cssColordcdcdc ctermfg=16
    hi cssColordcdcdc ctermbg=253
       

    syn keyword cssColorf8f8ff GhostWhite contained
    syn cluster cssColors add=cssColorf8f8ff
    hi cssColorf8f8ff ctermfg=16
    hi cssColorf8f8ff ctermbg=231
       

    syn keyword cssColorffd700 Gold contained
    syn cluster cssColors add=cssColorffd700
    hi cssColorffd700 ctermfg=16
    hi cssColorffd700 ctermbg=220
       

    syn keyword cssColordaa520 GoldenRod contained
    syn cluster cssColors add=cssColordaa520
    hi cssColordaa520 ctermfg=16
    hi cssColordaa520 ctermbg=178
       

    syn keyword cssColor808080 Grey contained
    syn cluster cssColors add=cssColor808080
    hi cssColor808080 ctermfg=16
    hi cssColor808080 ctermbg=244
       

    syn keyword cssColoradff2f GreenYellow contained
    syn cluster cssColors add=cssColoradff2f
    hi cssColoradff2f ctermfg=16
    hi cssColoradff2f ctermbg=154
       

    syn keyword cssColorf0fff0 HoneyDew contained
    syn cluster cssColors add=cssColorf0fff0
    hi cssColorf0fff0 ctermfg=16
    hi cssColorf0fff0 ctermbg=231
       

    syn keyword cssColorff69b4 HotPink contained
    syn cluster cssColors add=cssColorff69b4
    hi cssColorff69b4 ctermfg=16
    hi cssColorff69b4 ctermbg=205
       

    syn keyword cssColorcd5c5c IndianRed contained
    syn cluster cssColors add=cssColorcd5c5c
    hi cssColorcd5c5c ctermfg=16
    hi cssColorcd5c5c ctermbg=167
       

    syn keyword cssColor4b0082 Indigo contained
    syn cluster cssColors add=cssColor4b0082
    hi cssColor4b0082 ctermfg=231
    hi cssColor4b0082 ctermbg=54
       

    syn keyword cssColorfffff0 Ivory contained
    syn cluster cssColors add=cssColorfffff0
    hi cssColorfffff0 ctermfg=16
    hi cssColorfffff0 ctermbg=231
       

    syn keyword cssColorf0e68c Khaki contained
    syn cluster cssColors add=cssColorf0e68c
    hi cssColorf0e68c ctermfg=16
    hi cssColorf0e68c ctermbg=222
       

    syn keyword cssColore6e6fa Lavender contained
    syn cluster cssColors add=cssColore6e6fa
    hi cssColore6e6fa ctermfg=16
    hi cssColore6e6fa ctermbg=7
       

    syn keyword cssColorfff0f5 LavenderBlush contained
    syn cluster cssColors add=cssColorfff0f5
    hi cssColorfff0f5 ctermfg=16
    hi cssColorfff0f5 ctermbg=231
       

    syn keyword cssColor7cfc00 LawnGreen contained
    syn cluster cssColors add=cssColor7cfc00
    hi cssColor7cfc00 ctermfg=16
    hi cssColor7cfc00 ctermbg=118
       

    syn keyword cssColorfffacd LemonChiffon contained
    syn cluster cssColors add=cssColorfffacd
    hi cssColorfffacd ctermfg=16
    hi cssColorfffacd ctermbg=230
       

    syn keyword cssColoradd8e6 LightBlue contained
    syn cluster cssColors add=cssColoradd8e6
    hi cssColoradd8e6 ctermfg=16
    hi cssColoradd8e6 ctermbg=152
       

    syn keyword cssColorf08080 LightCoral contained
    syn cluster cssColors add=cssColorf08080
    hi cssColorf08080 ctermfg=16
    hi cssColorf08080 ctermbg=210
       

    syn keyword cssColore0ffff LightCyan contained
    syn cluster cssColors add=cssColore0ffff
    hi cssColore0ffff ctermfg=16
    hi cssColore0ffff ctermbg=195
       

    syn keyword cssColorfafad2 LightGoldenRodYellow contained
    syn cluster cssColors add=cssColorfafad2
    hi cssColorfafad2 ctermfg=16
    hi cssColorfafad2 ctermbg=230
       

    syn keyword cssColord3d3d3 LightGray contained
    syn cluster cssColors add=cssColord3d3d3
    hi cssColord3d3d3 ctermfg=16
    hi cssColord3d3d3 ctermbg=252
       

    syn keyword cssColord3d3d3 LightGrey contained
    syn cluster cssColors add=cssColord3d3d3
    hi cssColord3d3d3 ctermfg=16
    hi cssColord3d3d3 ctermbg=252
       

    syn keyword cssColor90ee90 LightGreen contained
    syn cluster cssColors add=cssColor90ee90
    hi cssColor90ee90 ctermfg=16
    hi cssColor90ee90 ctermbg=120
       

    syn keyword cssColorffb6c1 LightPink contained
    syn cluster cssColors add=cssColorffb6c1
    hi cssColorffb6c1 ctermfg=16
    hi cssColorffb6c1 ctermbg=217
       

    syn keyword cssColorffa07a LightSalmon contained
    syn cluster cssColors add=cssColorffa07a
    hi cssColorffa07a ctermfg=16
    hi cssColorffa07a ctermbg=216
       

    syn keyword cssColor20b2aa LightSeaGreen contained
    syn cluster cssColors add=cssColor20b2aa
    hi cssColor20b2aa ctermfg=16
    hi cssColor20b2aa ctermbg=37
       

    syn keyword cssColor87cefa LightSkyBlue contained
    syn cluster cssColors add=cssColor87cefa
    hi cssColor87cefa ctermfg=16
    hi cssColor87cefa ctermbg=117
       

    syn keyword cssColor778899 LightSlateGray contained
    syn cluster cssColors add=cssColor778899
    hi cssColor778899 ctermfg=16
    hi cssColor778899 ctermbg=102
       

    syn keyword cssColor778899 LightSlateGrey contained
    syn cluster cssColors add=cssColor778899
    hi cssColor778899 ctermfg=16
    hi cssColor778899 ctermbg=102
       

    syn keyword cssColorb0c4de LightSteelBlue contained
    syn cluster cssColors add=cssColorb0c4de
    hi cssColorb0c4de ctermfg=16
    hi cssColorb0c4de ctermbg=152
       

    syn keyword cssColorffffe0 LightYellow contained
    syn cluster cssColors add=cssColorffffe0
    hi cssColorffffe0 ctermfg=16
    hi cssColorffffe0 ctermbg=230
       

    syn keyword cssColor32cd32 LimeGreen contained
    syn cluster cssColors add=cssColor32cd32
    hi cssColor32cd32 ctermfg=16
    hi cssColor32cd32 ctermbg=40
       

    syn keyword cssColorfaf0e6 Linen contained
    syn cluster cssColors add=cssColorfaf0e6
    hi cssColorfaf0e6 ctermfg=16
    hi cssColorfaf0e6 ctermbg=230
       

    syn keyword cssColorff00ff Magenta contained
    syn cluster cssColors add=cssColorff00ff
    hi cssColorff00ff ctermfg=231
    hi cssColorff00ff ctermbg=13
       

    syn keyword cssColor66cdaa MediumAquaMarine contained
    syn cluster cssColors add=cssColor66cdaa
    hi cssColor66cdaa ctermfg=16
    hi cssColor66cdaa ctermbg=79
       

    syn keyword cssColorcd MediumBlue contained
    syn cluster cssColors add=cssColorcd
    hi cssColorcd ctermfg=231
    hi cssColorcd ctermbg=20
       

    syn keyword cssColorba55d3 MediumOrchid contained
    syn cluster cssColors add=cssColorba55d3
    hi cssColorba55d3 ctermfg=16
    hi cssColorba55d3 ctermbg=134
       

    syn keyword cssColor9370d8 MediumPurple contained
    syn cluster cssColors add=cssColor9370d8
    hi cssColor9370d8 ctermfg=16
    hi cssColor9370d8 ctermbg=98
       

    syn keyword cssColor3cb371 MediumSeaGreen contained
    syn cluster cssColors add=cssColor3cb371
    hi cssColor3cb371 ctermfg=16
    hi cssColor3cb371 ctermbg=35
       

    syn keyword cssColor7b68ee MediumSlateBlue contained
    syn cluster cssColors add=cssColor7b68ee
    hi cssColor7b68ee ctermfg=16
    hi cssColor7b68ee ctermbg=99
       

    syn keyword cssColorfa9a MediumSpringGreen contained
    syn cluster cssColors add=cssColorfa9a
    hi cssColorfa9a ctermfg=16
    hi cssColorfa9a ctermbg=48
       

    syn keyword cssColor48d1cc MediumTurquoise contained
    syn cluster cssColors add=cssColor48d1cc
    hi cssColor48d1cc ctermfg=16
    hi cssColor48d1cc ctermbg=44
       

    syn keyword cssColorc71585 MediumVioletRed contained
    syn cluster cssColors add=cssColorc71585
    hi cssColorc71585 ctermfg=231
    hi cssColorc71585 ctermbg=162
       

    syn keyword cssColor191970 MidnightBlue contained
    syn cluster cssColors add=cssColor191970
    hi cssColor191970 ctermfg=231
    hi cssColor191970 ctermbg=17
       

    syn keyword cssColorf5fffa MintCream contained
    syn cluster cssColors add=cssColorf5fffa
    hi cssColorf5fffa ctermfg=16
    hi cssColorf5fffa ctermbg=231
       

    syn keyword cssColorffe4e1 MistyRose contained
    syn cluster cssColors add=cssColorffe4e1
    hi cssColorffe4e1 ctermfg=16
    hi cssColorffe4e1 ctermbg=224
       

    syn keyword cssColorffe4b5 Moccasin contained
    syn cluster cssColors add=cssColorffe4b5
    hi cssColorffe4b5 ctermfg=16
    hi cssColorffe4b5 ctermbg=223
       

    syn keyword cssColorffdead NavajoWhite contained
    syn cluster cssColors add=cssColorffdead
    hi cssColorffdead ctermfg=16
    hi cssColorffdead ctermbg=223
       

    syn keyword cssColorfdf5e6 OldLace contained
    syn cluster cssColors add=cssColorfdf5e6
    hi cssColorfdf5e6 ctermfg=16
    hi cssColorfdf5e6 ctermbg=230
       

    syn keyword cssColor6b8e23 OliveDrab contained
    syn cluster cssColors add=cssColor6b8e23
    hi cssColor6b8e23 ctermfg=231
    hi cssColor6b8e23 ctermbg=64
       

    syn keyword cssColorff4500 OrangeRed contained
    syn cluster cssColors add=cssColorff4500
    hi cssColorff4500 ctermfg=231
    hi cssColorff4500 ctermbg=196
       

    syn keyword cssColorda70d6 Orchid contained
    syn cluster cssColors add=cssColorda70d6
    hi cssColorda70d6 ctermfg=16
    hi cssColorda70d6 ctermbg=170
       

    syn keyword cssColoreee8aa PaleGoldenRod contained
    syn cluster cssColors add=cssColoreee8aa
    hi cssColoreee8aa ctermfg=16
    hi cssColoreee8aa ctermbg=223
       

    syn keyword cssColor98fb98 PaleGreen contained
    syn cluster cssColors add=cssColor98fb98
    hi cssColor98fb98 ctermfg=16
    hi cssColor98fb98 ctermbg=120
       

    syn keyword cssColorafeeee PaleTurquoise contained
    syn cluster cssColors add=cssColorafeeee
    hi cssColorafeeee ctermfg=16
    hi cssColorafeeee ctermbg=159
       

    syn keyword cssColord87093 PaleVioletRed contained
    syn cluster cssColors add=cssColord87093
    hi cssColord87093 ctermfg=16
    hi cssColord87093 ctermbg=168
       

    syn keyword cssColorffefd5 PapayaWhip contained
    syn cluster cssColors add=cssColorffefd5
    hi cssColorffefd5 ctermfg=16
    hi cssColorffefd5 ctermbg=230
       

    syn keyword cssColorffdab9 PeachPuff contained
    syn cluster cssColors add=cssColorffdab9
    hi cssColorffdab9 ctermfg=16
    hi cssColorffdab9 ctermbg=223
       

    syn keyword cssColorcd853f Peru contained
    syn cluster cssColors add=cssColorcd853f
    hi cssColorcd853f ctermfg=16
    hi cssColorcd853f ctermbg=172
       

    syn keyword cssColorffc0cb Pink contained
    syn cluster cssColors add=cssColorffc0cb
    hi cssColorffc0cb ctermfg=16
    hi cssColorffc0cb ctermbg=218
       

    syn keyword cssColordda0dd Plum contained
    syn cluster cssColors add=cssColordda0dd
    hi cssColordda0dd ctermfg=16
    hi cssColordda0dd ctermbg=182
       

    syn keyword cssColorb0e0e6 PowderBlue contained
    syn cluster cssColors add=cssColorb0e0e6
    hi cssColorb0e0e6 ctermfg=16
    hi cssColorb0e0e6 ctermbg=152
       

    syn keyword cssColorbc8f8f RosyBrown contained
    syn cluster cssColors add=cssColorbc8f8f
    hi cssColorbc8f8f ctermfg=16
    hi cssColorbc8f8f ctermbg=138
       

    syn keyword cssColor4169e1 RoyalBlue contained
    syn cluster cssColors add=cssColor4169e1
    hi cssColor4169e1 ctermfg=231
    hi cssColor4169e1 ctermbg=26
       

    syn keyword cssColor8b4513 SaddleBrown contained
    syn cluster cssColors add=cssColor8b4513
    hi cssColor8b4513 ctermfg=231
    hi cssColor8b4513 ctermbg=88
       

    syn keyword cssColorfa8072 Salmon contained
    syn cluster cssColors add=cssColorfa8072
    hi cssColorfa8072 ctermfg=16
    hi cssColorfa8072 ctermbg=209
       

    syn keyword cssColorf4a460 SandyBrown contained
    syn cluster cssColors add=cssColorf4a460
    hi cssColorf4a460 ctermfg=16
    hi cssColorf4a460 ctermbg=215
       

    syn keyword cssColor2e8b57 SeaGreen contained
    syn cluster cssColors add=cssColor2e8b57
    hi cssColor2e8b57 ctermfg=231
    hi cssColor2e8b57 ctermbg=29
       

    syn keyword cssColorfff5ee SeaShell contained
    syn cluster cssColors add=cssColorfff5ee
    hi cssColorfff5ee ctermfg=16
    hi cssColorfff5ee ctermbg=231
       

    syn keyword cssColora0522d Sienna contained
    syn cluster cssColors add=cssColora0522d
    hi cssColora0522d ctermfg=231
    hi cssColora0522d ctermbg=130
       

    syn keyword cssColor87ceeb SkyBlue contained
    syn cluster cssColors add=cssColor87ceeb
    hi cssColor87ceeb ctermfg=16
    hi cssColor87ceeb ctermbg=117
       

    syn keyword cssColor6a5acd SlateBlue contained
    syn cluster cssColors add=cssColor6a5acd
    hi cssColor6a5acd ctermfg=231
    hi cssColor6a5acd ctermbg=62
       

    syn keyword cssColor708090 SlateGray contained
    syn cluster cssColors add=cssColor708090
    hi cssColor708090 ctermfg=16
    hi cssColor708090 ctermbg=66
       

    syn keyword cssColor708090 SlateGrey contained
    syn cluster cssColors add=cssColor708090
    hi cssColor708090 ctermfg=16
    hi cssColor708090 ctermbg=66
       

    syn keyword cssColorfffafa Snow contained
    syn cluster cssColors add=cssColorfffafa
    hi cssColorfffafa ctermfg=16
    hi cssColorfffafa ctermbg=231
       

    syn keyword cssColorff7f SpringGreen contained
    syn cluster cssColors add=cssColorff7f
    hi cssColorff7f ctermfg=16
    hi cssColorff7f ctermbg=48
       

    syn keyword cssColor4682b4 SteelBlue contained
    syn cluster cssColors add=cssColor4682b4
    hi cssColor4682b4 ctermfg=231
    hi cssColor4682b4 ctermbg=31
       

    syn keyword cssColord2b48c Tan contained
    syn cluster cssColors add=cssColord2b48c
    hi cssColord2b48c ctermfg=16
    hi cssColord2b48c ctermbg=180
       

    syn keyword cssColord8bfd8 Thistle contained
    syn cluster cssColors add=cssColord8bfd8
    hi cssColord8bfd8 ctermfg=16
    hi cssColord8bfd8 ctermbg=182
       

    syn keyword cssColorff6347 Tomato contained
    syn cluster cssColors add=cssColorff6347
    hi cssColorff6347 ctermfg=16
    hi cssColorff6347 ctermbg=202
       

    syn keyword cssColor40e0d0 Turquoise contained
    syn cluster cssColors add=cssColor40e0d0
    hi cssColor40e0d0 ctermfg=16
    hi cssColor40e0d0 ctermbg=44
       

    syn keyword cssColoree82ee Violet contained
    syn cluster cssColors add=cssColoree82ee
    hi cssColoree82ee ctermfg=16
    hi cssColoree82ee ctermbg=213
       

    syn keyword cssColorf5deb3 Wheat contained
    syn cluster cssColors add=cssColorf5deb3
    hi cssColorf5deb3 ctermfg=16
    hi cssColorf5deb3 ctermbg=223
       

    syn keyword cssColorf5f5f5 WhiteSmoke contained
    syn cluster cssColors add=cssColorf5f5f5
    hi cssColorf5f5f5 ctermfg=16
    hi cssColorf5f5f5 ctermbg=256
       

    syn keyword cssColor9acd32 YellowGreen contained
    syn cluster cssColors add=cssColor9acd32
    hi cssColor9acd32 ctermfg=16
    hi cssColor9acd32 ctermbg=112
   
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
