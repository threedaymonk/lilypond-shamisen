\version "2.18.2"

% Make the staff bigger. Do this before including shamisen.ly
#(set-global-staff-size 32)

% Use s/f for sharp/flat
\language "english"
\include "shamisen.ly"

\paper{
  #(set-paper-size "a4")
  #(define fonts
    (set-global-fonts
     #:roman "IPAexGothic" ; this must be an available font with Japanese characters
     #:factor (/ staff-height pt 20) ; unnecessary if the staff size is default
    ))
}

% If this font is not available, replace with one that is
% shamisen-markup-font = #'(font-name . "IPAexGothic")

\header {
  title = "例"
  subtitle = "Example"
  meter = "2/4 二上り"
  tagline = "Typeset with LilyPond and shamisen.ly"
}

\score {
  \new TabStaff {
    \set TabStaff.stringTunings = #niagariTuning
    \shamisenNotation
    \time 2/4

    c'8. bf16 g bf \uchi c'8

    g8. f16^\third g bf \uchi c'8

    g8. f16 g8. ef16

    f8.^\third g16
    \trtr { c'16\2^\third bf \hajiki g \hajiki g }

    c'8 c' \sukui
    \trtr { f'16 ef' \hajiki c' \hajiki bf }

    g16 bf \uchi c'8 r4

    g8. f16 g8. <c g c'>16

    <c g c'>2\fermata
  }
}
