% Shamisen notation for LilyPond
%
% For more information and updates, visit:
% https://github.com/threedaymonk/lilypond-shamisen

shamisen-markup-font = #'(font-name . "IPAexGothic")

\layout {
  \context {
    \Score
    tablatureFormat =
      #(lambda (context string-number fret-number)
        (let* ((shami-tab-signs
                '(0 1 2 3 "#" 4 5 6 7 8 9 "b" 10 11 12 13 "1#" 14 15 16 17 18))
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
  (let* ((width 0.8)
         (thickness 0.15)
         (spacing 0.3))
    (ly:stencil-translate
      (grob-interpret-markup grob
        (markup
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

#(define (dot-rests grob)
  (let* ((duration (ly:grob-property grob 'duration-log))
         (lines (- duration 2))
         (top -0.8)
         (dia 0.4)
         (circle (ly:stencil-translate-axis (make-circle-stencil dia 0.1 #t) dia X)))
    (case duration
      ((2) circle)
      ((3 4 5)
        (ly:stencil-add
          circle
          (draw-underbars grob dia top lines)))
      (else (ly:rest::print grob)))))

#(define (underbars grob)
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
  \lower #0.5
  \override \shamisen-markup-font \center-align \teeny "ハ"
}
sukui-markup = \markup {
  \lower #0.5
  \override \shamisen-markup-font \center-align \teeny "ス"
}
uchi-markup = \markup {
  \lower #0.5
  \override \shamisen-markup-font \center-align \teeny "ウ"
}
oshi-markup = \markup {
  \override \shamisen-markup-font \center-align \teeny "⅃"
}
keshi-markup = \markup {
  \override \shamisen-markup-font \center-align \teeny "ケ"
}
first = \markup {
  \override \shamisen-markup-font \teeny "Ⅰ"
}
second = \markup {
  \override \shamisen-markup-font \teeny "Ⅱ"
}
third = \markup {
  \override \shamisen-markup-font \teeny "Ⅲ"
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

  \override TabStaff.Stem.stencil = #underbars
  \revert TabStaff.Rest.stencil
  \override Rest #'stencil = #dot-rests
  \override Stem.direction = #DOWN
  \override Stem.length = 0
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
