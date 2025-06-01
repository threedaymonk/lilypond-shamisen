% Shamisen notation for LilyPond
%
% For more information and updates, visit:
% https://github.com/threedaymonk/lilypond-shamisen

% This is the default, but we set it here to ensure that our note names work
% in the tunings defined below.
\language "nederlands"

tsugaru-signs =
#'( 0  1  2  3   "♯"  4  5  6  7  8  9  "9♯"
   10 11 12 13 "13♯" 14 15 16 17 18 19 "19♯"
   20 21 22 23 "23♯" 24 25 26)

tsugaru-signs-with-flats =
#'( 0  1  2  3  "4♭"  4  5  6  7  8  9 "10♭"
   10 11 12 13 "14♭" 14 15 16 17 18 19 "20♭"
   20 21 22 23 "24♭" 24 25 26)

#(define (custom-tab-format tab-signs)
  (lambda (context string-number fret-number)
    (let* ((ls-length (length tab-signs))
           (my-sign
             (if (> fret-number (1- ls-length))
                 fret-number
                 (list-ref tab-signs fret-number))))
     (if (integer? fret-number)
         (make-vcenter-markup
           (format #f "~a" my-sign ))
         (fret-number-tablature-format context string-number fret-number)))))

#(define (draw-underbars grob x-shift top lines)
  (let* ((width 1.1)
         (thickness 0.12)
         (spacing (/ 0.6 lines)))
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

#(define (draw-elongator grob)
  (let* ((x-offset 2)
         (y-offset 0.67)
         (width 1)
         (thickness 0.12))
    (ly:stencil-translate
      (grob-interpret-markup grob
        (markup
          #:override '(line-cap-style . square)
          (#:path thickness
           `((moveto ,x-offset ,y-offset)
             (rlineto ,width 0)))))
      (cons 0 (interval-start '(0 . 0))))))

#(define (dot-rest-stencil grob)
  (let* ((duration (ly:grob-property grob 'duration-log))
         (lines (- duration 2))
         (top -0.8)
         (radius 0.45)
         (circle (ly:stencil-translate-axis (make-circle-stencil radius 0 #t) radius X)))
    (case duration
      ((1)
        (ly:stencil-add
          circle
          (draw-elongator grob)))
      ((2) circle)
      ((3 4 5)
        (ly:stencil-add
          circle
          (draw-underbars grob radius top lines)))
      (else (ly:rest::print grob)))))

#(define (scaling-tab-note-head-stencil grob)
  (let* ((width (string-length (cadr (ly:grob-property grob 'text))))
         (x-scale (/ (+ (/ 1 width) 1) 2))
         (stencil (ly:stencil-scale (tab-note-head::print grob) x-scale 1)))
    stencil))

#(define (underbar-stem-stencil grob)
  (if (ly:stencil? (ly:stem::print grob))
    (let* ((stencil (ly:stem::print grob))
           (duration (ly:grob-property grob 'duration-log))
           (lines (- duration 2))
           (Y-ext (ly:stencil-extent stencil Y))
           (top (cdr Y-ext)))
      (case duration
        ((1) (draw-elongator grob))
        ((3 4 5) (draw-underbars grob 0 top lines))
        (else #f)))))

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
  #'((moveto -1.0 -0.1)
     (lineto 0.0 -0.1)
     (lineto 0.0 0.5))
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

#(append! default-script-alist
  (list
    `(hajiki
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,hajiki-markup)
        (quantize-position . #t)
        (avoid-slur . around)
        (direction . ,DOWN)))
    `(sukui
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,sukui-markup)
        (quantize-position . #t)
        (avoid-slur . around)
        (direction . ,DOWN)))
   `(uchi
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,uchi-markup)
        (quantize-position . #t)
        (avoid-slur . around)
        (direction . ,DOWN)))
   `(oshi
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,oshi-markup)
        (quantize-position . #t)
        (avoid-slur . around)
        (direction . ,DOWN)))
   `(keshi
      . (
        (stencil . ,ly:text-interface::print)
        (text . ,keshi-markup)
        (quantize-position . #t)
        (avoid-slur . around)
        (direction . ,DOWN)))))

hajiki = #(make-articulation 'hajiki)
sukui  = #(make-articulation 'sukui)
uchi   = #(make-articulation 'uchi)
oshi   = #(make-articulation 'oshi)
keshi  = #(make-articulation 'keshi)

first  = \markup { \teeny "Ⅰ" }
second = \markup { \teeny "Ⅱ" }
third  = \markup { \teeny "Ⅲ" }

trtr =
#(define-music-function
  (parser location music)
  (ly:music?)
  (let* ((es (ly:music-property music 'elements))
         (unsquashed (make-music 'SequentialMusic 'elements (take es 1)))
         (squashed (make-music 'SequentialMusic 'elements (drop es 1))))
    #{
      #unsquashed
      \override NoteColumn.X-offset = -2
      #squashed
      \revert NoteColumn.X-offset
    #}))

#(define (is-shamisen-articulation art)
   (let* ((atype (ly:music-property art 'articulation-type))
          (aname (ly:music-property art 'name))
          (atypes '(hajiki sukui uchi oshi keshi))
          (anames '(StringNumberEvent TextScriptEvent)))
     (cond ((member atype atypes) #t)
           ((member aname anames) #t)
           (else #f))))

stripShamisenArticulations =
  #(define-music-function (parser location music) (ly:music?)
    (music-map
     (lambda (m)
      (let* ((arts (ly:music-property m 'articulations)))
      (if (not (null? arts))
          (ly:music-set-property! m 'articulations (remove is-shamisen-articulation arts))))
      m)
     music))

shamisenNotation = {
  % Restore behaviour that is turned off by default in tablature
  \revert TabStaff.Script.stencil
  \revert TabStaff.TextScript.stencil
  \revert TabStaff.NoteColumn.ignore-collision
  \revert TabStaff.Dots.stencil
  \revert TabStaff.Slur.stencil
  \revert TabStaff.PhrasingSlur.stencil
  \revert TabStaff.TupletBracket.stencil
  \revert TabStaff.TupletNumber.stencil
  \revert TabStaff.Tie.stencil
  \revert TabStaff.Tie.after-line-breaking

  % Draw underbars instead of note tails, and dots for rests
  \override TabStaff.Stem.stencil = #underbar-stem-stencil
  \override TabStaff.Stem.direction = #DOWN
  \override TabStaff.Stem.length = #0.9
  \override TabStaff.Rest.stencil = #dot-rest-stencil
  \override TabStaff.TabNoteHead.stencil = #scaling-tab-note-head-stencil

  % Turn off the TAB clef
  \override TabStaff.Clef.stencil = ##f

  % Use Tsugaru position numbering
  \set TabStaff.tablatureFormat = #(custom-tab-format tsugaru-signs)
}

honchoushiTuning = \stringTuning <c f c'>
niagariTuning    = \stringTuning <c g c'>
sansagariTuning  = \stringTuning <c f bes>
