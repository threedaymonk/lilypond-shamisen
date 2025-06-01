# Tsugaru shamisen notation for LilyPond

Lilypond target version: 2.24

![Sample output](example.svg)

This is a work in progress, but should be adequate for most pieces.
Contributions, bug reports, and suggestions are very welcome.

## Usage

If you're familiar with Git, clone this repository and add it to LilyPond's
include path. If not, the simplest way to get started is to
[download the latest version of `shamisen.ly`](https://raw.githubusercontent.com/threedaymonk/lilypond-shamisen/docs/shamisen.ly)
and put it in the same directory as the `.ly` file you're working on.

Include shamisen support:

    \include "shamisen.ly"

The default staff size is quite small. Make it bigger if you wish:

    #(set-global-staff-size 24)

Depending on your system, the default font might not support Japanese. However,
even if it does, you might want to change it anyway; see the section on Fonts
below.

    \paper{
      #(define fonts
        (set-global-fonts
         #:roman "IPAexGothic"
         #:factor (/ staff-height pt 20)
        ))
    }

Create a tab staff, set the tuning, tell it to use shamisen notation, and
insert notes according to the usual
[LilyPond text format](http://lilypond.org/text-input.html):

    \score {
      \new TabStaff {
        \set TabStaff.stringTunings = #niagariTuning
        \shamisenNotation
        \time 2/4

        c8 es f g % etc. etc.

      }
    }

### Predefined tunings

- `honchoushiTuning` (C F C')
- `niagariTuning` (C G C')
- `sansagariTuning` (C F B♭')

### String selection

The default behaviour of LilyPond is to place notes on the lowest position
(i.e. the highest string) possible. This can be overridden in the normal way:

    c'\2 % play on the middle string（２の糸）
    c'\3 % play on the lowest string（１の糸）

Note that LilyPond numbers the strings in the *opposite* way from
normal shamisen usage: the lowest string is 3, and the highest is 1.

(Although it is possible to reverse the order of strings and tablature in
LilyPond and thus use the shamisen numbering convention, this breaks
automatic note placement, with the result that all notes are placed on the
lowest string. As this is more annoying than reversed numbering, we don't do
this.)

### Annotations

These extend the normal LilyPond annotations to add:

- `\hajiki` left-hand pluck ハ
- `\sukui` upstroke ス
- `\uchi` hammer-on ウ
- `\oshi` oshibachi ⅃
- `\keshi` mute ケ

Example:

    g \hajiki

### Fingering indications

This can be achieved in the normal way, but for convenience Roman numerals for
Ⅰ, Ⅱ, Ⅲ are defined as `\first`, `\second`, `\third` etc.:

    f16^\third

### Underlines for note lengths

These are entered as notes in the normal way:

    c4  % -> 0
    c8  % -> 0 with single underline
    c8. % -> 0 with single underline and dot
    c16 % -> 0 with double underline
    c32 % -> 0 with triple underline

### Dot rests

These are entered as rests in the normal way:

    r4 % -> dot
    r8 % -> dot with single underline
    % etc.

### 4300 phrases and similar

The `\trtr { ... }` (TsuRuTaRa) function squashes the spacing of the
notes within the braces:

    \trtr { c'16\2^\third bes \hajiki g \hajiki g }

### Positions 10 and higher

By default, double- and triple-character position numbers are compressed to 3/4
and 2/3 of the normal width, respectively. This can be turned off in favour
of LilyPond's default tablature rendering:

    \revert TabStaff.TabNoteHead.stencil

### Sharp and flat positions

There are two options for displaying these non-numbered positions:

* With sharps (♯, 9♯, 13♯ etc.)
* With flats (4♭, 10♭, 14♭ etc.)

The default is to use sharps. Flats can be selected instead:

    \set TabStaff.tablatureFormat = #(custom-tab-format tsugaru-signs-with-flats)

## Implementation notes

Underlining of notes is implemented as a different stencil for the note stem.

The non-semitonal numbering of positions is achieved by a lookup function.

Hajiki, sukui, etc. are normal annotations, using custom stencils.

## Bonus

Also included is a small Ruby program that can convert a simple LilyPond-like
language based on tablature into notes, to assist in transcribing existing
works. See sakura-sakura.input.ly for an example of how this works.

## Fonts

It is no longer necessary to use a Japanese font. However, in my opinion, the
look of a Japanese gothic (≈ sans serif) font is more appropriate for shamisen
scores than the default Lilypond font.

The font *IPAexGothic* works well and is free to download from the website of
the [CITPC] in Japan (file [ipaexg00401.zip]) or can be obtained by installing
the `fonts-ipaexfont` package on Ubuntu or Debian.

[CITPC]: https://moji.or.jp/ipafont/ipafontdownload/
[ipaexg00401.zip]: https://moji.or.jp/wp-content/ipafont/IPAexfont/ipaexg00401.zip
