\version "2.18.2"
\include "../shamisen.ly"
\language "english"

#(set-global-staff-size 24)

\paper{
  #(define fonts
    (set-global-fonts
     #:roman "IPAexGothic"
     #:factor (/ staff-height pt 20) ; unnecessary if the staff size is default
    ))
}

\header {
  title = "さくらさくら"
  subtitle = "Sakura Sakura"
  meter = "2/4 二上り"
  tagline = ""
}

song = {
  \time 2/4

%{ shamisen
  tuning niagari

  4-4\3 i 4
  6 iii r
  4 i 4
  6 iii r

  4 i 6 i
  7 ii 6 i
  4 6-8 iii 4 ha
  5-4\2! ii r

  0-4\3 1\2 i
  0\3 1 i
  0 0-8 1\2 i
  0-4 r

  4\3 i 6 i
  7 ii 6 i
  4 6-8 4 ha
  5-4\2! ii r

  0-4\3 1\2 i
  0\3 1 i
  0 0-8 1\2 i
  0-4 r

  4-4\3 i 4
  6 iii r
  4 i 4
  6 iii r

  3\2 i 0\3
  1 i r
  6-8 iii 4 ha 5-4\2!
  <0\2 0\3>2 \fermata
%}

}

\score {
  <<
    \new TabStaff {
      \set TabStaff.stringTunings = #niagariTuning
      \shamisenNotation
      \song
    }
  >>
}
