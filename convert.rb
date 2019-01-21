TUNINGS = {
  'honchoushi' => [['c', 0],  ['f', 0], ['c', 1]],
  'niagari' => [['c', 0], ['g', 0], ['c', 1]],
  'sansagari' => [['c', 0],  ['f', 0], ['bf', 1]],
}

POSITIONS = %w[ 0 1 2 3 # 4 5 6 7 8 9 b ]

def position_to_offset(p)
  if p.length > 1
    octave = p[0].to_i
  else
    octave = 0
  end
  rel = p[-1]
  POSITIONS.index(rel) + octave * 12
end

NOTE_NAMES = %w[ c df d ef e f gf g af a bf b ]

def offset_to_note(open_name, open_octave, offset)
  abs = (offset + NOTE_NAMES.index(open_name)) + open_octave * 12
  octave = abs / 12
  rel = abs % 12

  NOTE_NAMES.fetch(rel) + "'" * octave
end

tuning =  TUNINGS['niagari']
string = 1

require 'strscan'

s = StringScanner.new(ARGF.read)

until s.eos?
  if s.scan(/\s*iii/)
    print '^\\third'
  elsif s.scan(/\s*ii/)
    print '^\\second'
  elsif s.scan(/\s*i/)
    print '^\\first'
  elsif s.scan(/ha/)
    print '\\hajiki'
  elsif s.scan(/su/)
    print '\\sukui'
  elsif s.scan(/u/)
    print '\\uchi'
  elsif s.scan(/\s+|r\d*|</)
    print s[0]
  elsif s.scan(/tuning\s+(?<name>\w+)/)
    tuning = TUNINGS.fetch(s[:name])
  elsif s.scan(/[0-9#b]+/)
    offset = position_to_offset(s[0])
    duration = nil
    if s.scan(/-(?<duration>\d+)/)
      duration = s[:duration]
    end
    if s.scan(/\\(?<string>\d)/)
      string = s[:string].to_i
    end
    open_name, open_octave = tuning.fetch(string - 1)
    note = offset_to_note(open_name, open_octave, offset)
    print "#{note}#{duration}"

    if s.scan(/!/)
      print "\\#{string}"
    end
  elsif s.scan(/\S+/)
    print s[0]
  end
end
