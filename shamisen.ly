shamisen-markup-font = #'(font-name . "IPAPGothic")

underbar-width =  0.8

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

#(define (dot-rests grob)
  (let* ((duration (ly:grob-property grob 'duration-log))
         (lines (- duration 2))
         (top -0.8)
         (circle (ly:stencil-translate-axis (make-circle-stencil 0.4 0.1 #t) 0.4 X)))
    (case duration
      ((2) circle)
      ((3 4 5)
        (ly:stencil-add
          circle
          (ly:stencil-translate
           (grob-interpret-markup grob
             (markup
               (#:path 0.15
                 (fold
                   (lambda (e a)
                     (cons*
                       (list 'moveto 0 (- top (* e 0.3)))
                       (list 'lineto underbar-width (- top (* e 0.3)))
                       a))
                   '()
                   (iota lines)))))
           (cons 0 (interval-start '(0 . 0))))))
      (else (ly:rest::print grob)))
  )
)

#(define (underbars grob)
   %(if (ly:stencil? (ly:stem::print grob))
     (let* ((stencil (ly:stem::print grob))
            (duration (ly:grob-property grob 'duration-log))
            (lines (- duration 2))
            (X-ext (ly:stencil-extent stencil X))
            (Y-ext (ly:stencil-extent stencil Y))
            (top (cdr Y-ext))
            (width (interval-length X-ext))
            (len (interval-length Y-ext)))
       (if (> lines 0)
         (ly:stencil-translate
           (grob-interpret-markup grob
             (markup
               (#:path 0.15
                 (fold
                   (lambda (e a)
                     (cons*
                       (list 'moveto (- 0 (/ underbar-width 2)) (- top (* e 0.3)))
                       (list 'lineto (/ underbar-width 2) (- top (* e 0.3)))
                       a))
                   '()
                   (iota lines)))))
           (cons 0 (interval-start '(0 . 0))))
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
        (direction . ,DOWN)))))

hajiki = #(make-articulation "hajiki")
sukui = #(make-articulation "sukui")
uchi = #(make-articulation "uchi")
oshi = #(make-articulation "oshi")

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
  #})
