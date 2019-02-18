% Shamisen notation for LilyPond
%
% For more information and updates, visit:
% https://github.com/threedaymonk/lilypond-shamisen

\layout {
  \context {
    \Score
    tablatureFormat =
      #(lambda (context string-number fret-number)
        (let* ((shami-tab-signs
                '(0   1  2  3  "♯"  4  5  6  7  8  9  "♭"
                  10 11 12 13 "1♯" 14 15 16 17 18 19 "1♭"
                  20 21 22 23 "2♯" 24 25 26))
               (ls-length (length shami-tab-signs))
               (my-sign
                 (if (> fret-number (1- ls-length))
                     fret-number
                     (list-ref shami-tab-signs fret-number))))
         (if (integer? fret-number)
             (make-vcenter-markup
               (format #f "~a" my-sign ))
             (fret-number-tablature-format context string-number fret-number))))
  }
  \context {
    \TabStaff
    \remove "Clef_engraver"
  }
}

#(define (draw-underbars grob x-shift top lines)
  (let* ((width 1.1)
         (thickness 0.12)
         (spacing 0.3))
    (ly:stencil-translate
      (grob-interpret-markup grob
        (markup
          #:override '(line-cap-style . square)
          (#:path thickness
            (fold
              (lambda (e a)
                (cons*
                  (list 'moveto (- x-shift (/ width 2)) (- top (* e spacing)))
                  (list 'lineto (+ x-shift (/ width 2)) (- top (* e spacing)))
                  a))
              '()
              (iota lines)))))
      (cons 0 (interval-start '(0 . 0))))))

#(define (dot-rest-stencil grob)
  (let* ((duration (ly:grob-property grob 'duration-log))
         (lines (- duration 2))
         (top -0.8)
         (radius 0.45)
         (circle (ly:stencil-translate-axis (make-circle-stencil radius 0 #t) radius X)))
    (case duration
      ((2) circle)
      ((3 4 5)
        (ly:stencil-add
          circle
          (draw-underbars grob radius top lines)))
      (else (ly:rest::print grob)))))

#(define (underbar-stem-stencil grob)
  (if (ly:stencil? (ly:stem::print grob))
    (let* ((stencil (ly:stem::print grob))
           (duration (ly:grob-property grob 'duration-log))
           (lines (- duration 2))
           (Y-ext (ly:stencil-extent stencil Y))
           (top (cdr Y-ext)))
      (if (> lines 0)
        (draw-underbars grob 0 top lines)
        #f))
      #f))

hajiki-markup = \markup {
  \override #'(line-cap-style . square)
  \override #'(line-join-style . miter)
  \path #0.12
  #'((moveto -0.212 0.334)
     (curveto -0.289 0.053 -0.409 -0.157 -0.553 -0.338)
     (moveto 0.155 0.352)
     (curveto 0.328 0.106 0.458 -0.114 0.545 -0.307))
}
sukui-markup = \markup {
  \override #'(line-cap-style . square)
  \override #'(line-join-style . miter)
  \path #0.12
	#'((moveto -0.412 0.422)
		 (lineto 0.228 0.427)
		 (lineto 0.268 0.386)
		 (curveto 0.110 -0.046 -0.131 -0.276 -0.487 -0.457)
		 (moveto 0.494 -0.434)
		 (curveto 0.379 -0.313 0.247 -0.187 0.044 -0.036))
}
uchi-markup = \markup {
  \override #'(line-cap-style . square)
  \override #'(line-join-style . miter)
  \path #0.12
	#'((moveto -0.394 -0.055)
		 (lineto -0.389 0.293)
		 (lineto 0.372 0.293)
		 (lineto 0.402 0.270)
		 (curveto 0.371 -0.116 0.197 -0.391 -0.173 -0.505)
		 (moveto -0.001 0.570)
		 (lineto -0.001 0.310))
}
oshi-markup = \markup {
  \override #'(line-cap-style . square)
  \override #'(line-join-style . miter)
  \path #0.12
  #'((moveto -1.0 0.0)
     (lineto 0.0 0.0)
     (lineto 0.0 0.6))
}
keshi-markup = \markup {
  \override #'(line-cap-style . square)
  \override #'(line-join-style . miter)
  \path #0.12
	#'((moveto -0.168 0.552)
		 (curveto -0.245 0.221 -0.377 0.048 -0.508 -0.084)
		 (moveto -0.250 0.257)
		 (lineto 0.530 0.257)
		 (moveto 0.158 0.262)
		 (curveto 0.186 -0.065 0.086 -0.342 -0.254 -0.523))
}
first = \markup {
  \teeny "Ⅰ"
}
second = \markup {
  \teeny "Ⅱ"
}
third = \markup {
  \teeny "Ⅲ"
}

#(append! default-script-alist
  (list
    `("hajiki"
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,hajiki-markup)
        (quantize-position . #t)
        (direction . ,DOWN)))
    `("sukui"
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,sukui-markup)
        (quantize-position . #t)
        (direction . ,DOWN)))
   `("uchi"
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,uchi-markup)
        (quantize-position . #t)
        (direction . ,DOWN)))
   `("oshi"
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,oshi-markup)
        (quantize-position . #t)
        (direction . ,DOWN)))
   `("keshi"
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,keshi-markup)
        (quantize-position . #t)
        (direction . ,DOWN)))))

hajiki = #(make-articulation "hajiki")
sukui = #(make-articulation "sukui")
uchi = #(make-articulation "uchi")
oshi = #(make-articulation "oshi")
keshi = #(make-articulation "keshi")

shamisenNotation = {
  \revert TabStaff.Script.stencil
  \revert TabStaff.TextScript.stencil
  \revert TabStaff.NoteColumn.ignore-collision
  \revert TabStaff.Dots.stencil
  \revert TabStaff.Stem.stencil

  \revert TabStaff.Slur.stencil
  \revert TabStaff.PhrasingSlur.stencil

  \revert TabStaff.TupletBracket.stencil
  \revert TabStaff.TupletNumber.stencil

  \override TabStaff.Stem.stencil = #underbar-stem-stencil
  \revert TabStaff.Rest.stencil
  \override Rest #'stencil = #dot-rest-stencil
  \override Stem.direction = #DOWN
  \override Stem.length = #0.9
}

honchoushiTuning = \stringTuning <c f c'>
niagariTuning = \stringTuning <c g c'>
sansagariTuning = \stringTuning <c f bf'>

trtr =
#(define-music-function
  (parser location music)
  (ly:music?)
  #{
    \newSpacingSection
    \override Score.SpacingSpanner.average-spacing-wishes = ##f
    \override Score.SpacingSpanner.shortest-duration-space = #0
    #music
    \newSpacingSection
    \revert Score.SpacingSpanner.average-spacing-wishes
    \revert Score.SpacingSpanner.shortest-duration-space
    \once \override NoteColumn.X-offset = 1
  #})
