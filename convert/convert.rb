require 'strscan'

class NewLineChomper
  def initialize(io = $stdout)
    @io = io
    @consecutive_newlines = 0
  end

  def print(s)
    s.chars.each do |c|
      emit c
    end
  end

  def emit(c)
    if c == "\n"
      if @consecutive_newlines < 2
        @io.print c
      end
      @consecutive_newlines += 1
    else
      @io.print c
      @consecutive_newlines = 0
    end
  end
end

class Parser
  TUNINGS = {
    'honchoushi' => [['c', 0],  ['f', 0], ['c', 1], [4, 6]],
    'niagari' => [['c', 0], ['g', 0], ['c', 1], [6, 4]],
    'sansagari' => [['c', 0],  ['f', 0], ['bf', 1], [4, 4]],
  }

  POSITIONS = %w[ 0 1 2 3 # 4 5 6 7 8 9 b ]

  NOTE_NAMES = %w[ c df d ef e f gf g af a bf b ]

  def initialize
    @tuning = TUNINGS['niagari']
    @string = 1
  end

  def parse(src, dest)
    s = StringScanner.new(src.read)
    parse_lilypond dest, s
  end

private

  def position_to_offset(p)
    if p.length > 1
      octave = p[0].to_i
    else
      octave = 0
    end
    rel = p[-1]
    POSITIONS.index(rel) + octave * 12
  end

  def offset_to_note(open_name, open_octave, offset)
    abs = (offset + NOTE_NAMES.index(open_name)) + open_octave * 12
    octave = abs / 12
    rel = abs % 12

    NOTE_NAMES.fetch(rel) + "'" * octave
  end

  def parse_lilypond(io, s)
    until s.eos?
      if s.scan(/%{\s+shamisen\s*/)
        parse_shamisen io, s
      elsif s.scan(/.|\n/)
        io.print s[0]
      else
        raise "No idea at #{s}"
      end
    end
  end

  def parse_shamisen(io, s)
    until s.eos?
      if s.scan(/%}\s*/)
        return
      elsif s.scan(/%\s*(.*)/)
        io.print s[1]
      elsif s.scan(/\s*iii/)
        io.print '^\\third'
      elsif s.scan(/\s*ii/)
        io.print '^\\second'
      elsif s.scan(/\s*i/)
        io.print '^\\first'
      elsif s.scan(/ha/)
        io.print '\\hajiki'
      elsif s.scan(/su/)
        io.print '\\sukui'
      elsif s.scan(/u/)
        io.print '\\uchi'
      elsif s.scan(/o/)
        io.print '\\oshi'
      elsif s.scan(/\s+|r\d*|</)
        io.print s[0]
      elsif s.scan(/tuning\s+(?<name>\w+)/)
        @tuning = TUNINGS.fetch(s[:name])
      elsif s.scan(/[0-9#b]+/)
        offset = position_to_offset(s[0])
        duration = nil
        if s.scan(/-(?<duration>\d+\.?)/)
          duration = s[:duration]
        end
        if s.scan(/\\(?<string>\d)/)
          @string = s[:string].to_i
        end
        open_name, open_octave = @tuning.fetch(@string - 1)
        note = offset_to_note(open_name, open_octave, offset)
        io.print "#{note}#{duration}"

        if s.scan(/!/) || need_string(offset)
          io.print "\\#{@string}"
        end
      elsif s.scan(/\S+/)
        io.print s[0]
      else
        raise "No idea at #{s}"
      end
    end
  end

  def need_string(offset)
    t1, t2 = @tuning[3]
    case @string
    when 1
      offset >= t1
    when 2
      offset >= t2
    else
      false
    end
  end
end

Parser.new.parse(ARGF, NewLineChomper.new)
