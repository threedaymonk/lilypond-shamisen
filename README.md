# Shamisen notation for LilyPond

This is a work in progress, but should be adequate for most pieces.

## Features

* underlining of 8th. 16th, 32nd notes
* kana annotations for `\hajiki`, `\sukui`, `\uchi`
* fingering indications `^\first`, `^\second`, `^\third`
* dot rests (with underlines)
* predefined tunings:
  - `honchoushiTuning` (c f c')
  - `niagariTuning` (c g c')
  - `sansagariTuning` (c f bf')

## Missing

* suberi - can use a slur as a stand-in or annotate with an appropriate Unicode glyph
* half-note length indicators - these can probably be inferred from the bar length

## Implementation notes

Underlining of notes is implemented as a different stencil for the note stem.

The non-semitonal numbering of positions is achieved by a lookup function.

Hajiki, sukui, and uchi are normal annotations, using text markup.
