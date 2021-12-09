#!/usr/bin/env ruby

require 'byebug'
require 'set'

input = File.read("./inputs/day_8.txt")
lines = input.split("\n").map

REFERENCE_SEGMENTS = {
  0 => "abcefg",
  1 => "cf",
  2 => "acdeg",
  3 => "acdfg",
  4 => "bcdf",
  5 => "abdfg",
  6 => "abdefg",
  7 => "acf",
  8 => "abcdefg",
  9 => "abcdfg"
}

# gonna need some stronger potions for this one (a class that's self-aware, I think)

class OutputLine
  attr_reader :raw_input, :raw_output

  UNIQUE_LENGTHS = Set.new([2,4,3,7])
  UNIQUE_LENGTH_MAP = {
    2 => 1,
    4 => 4,
    3 => 7,
    7 => 8
  }
  def initialize(line)
    @raw_input, @raw_output = line.split(" | ")
    @input_digits = @raw_input.split(" ")
    @output_digits = @raw_output.split(" ")
    @map = (0..9).to_a.map do |digit|
      [digit, []]
    end.to_h
    @segment_map = {}
    build_map!
  end

  def unique_in_output
    uniques = 0
    @raw_output.split(" ").each do |digit|
      if UNIQUE_LENGTHS.include?(digit.length)
        uniques += 1
      end
    end
    uniques
  end

  def print_info
    puts "#{@raw_input} | #{@raw_output}"
    puts @map.inspect
    puts translate_output.inspect
  end

  def each_digit
    (@input_digits + @output_digits).each do |sequence|
      yield sequence
    end
  end

#    0:      1:      2:      3:      4:
#   aaaa    ....    aaaa    aaaa    ....
#  b    c  .    c  .    c  .    c  b    c
#  b    c  .    c  .    c  .    c  b    c
#   ....    ....    dddd    dddd    dddd
#  e    f  .    f  e    .  .    f  .    f
#  e    f  .    f  e    .  .    f  .    f
#   gggg    ....    gggg    gggg    ....
 
#    5:      6:      7:      8:      9:
#   aaaa    aaaa    aaaa    aaaa    aaaa
#  b    .  b    .  .    c  b    c  b    c
#  b    .  b    .  .    c  b    c  b    c
#   dddd    dddd    ....    dddd    dddd
#  .    f  e    f  .    f  e    f  .    f
#  .    f  e    f  .    f  e    f  .    f
#   gggg    gggg    ....    gggg    gggg

  def build_map!
    puts " ---- building map"
    # let's get the known ones squared away
    each_digit do |sequence|
      if UNIQUE_LENGTHS.include?(sequence.length)
        @map[UNIQUE_LENGTH_MAP[sequence.length]] = sequence.chars.sort
      end
    end
    # # try and figure out top segment
    # unless @map[1].empty? && @map[7].empty?
    #   top_segment = @map[7] - @map[1]
    # end
    # # puts top_segment
    # # ok, through testing it looks like top_segment is determinable in every example here. nice!
    # @segment_map["g"] = top_segment
    # # try and figure out bottom segment
    # bottom_segment = nil
    # unless @map[1].empty? && @map[7].empty? && @map[4].empty?
    #   each_digit do |sequence|
    #     seq = sequence.chars
    #     subtractive = seq - (@map[1] - @map[4] - @map[7]).uniq
    #     puts subtractive.inspect
    #     if subtractive.length == 1
    #       bottom_segment = subtractive.first
    #       break
    #     end
    #   end
    # end
    # puts "bottom segment: #{bottom_segment}"
    each_digit do |segment|
      puts "segment: #{segment}"
      poss = possibilities(segment)
      puts "possibilities: #{poss.inspect}"
      if poss.length == 1
        if poss.first == 9
          bottom_left_segment = "abcdefg".chars - segment.chars
          # puts "bl determined: #{bottom_left_segment}"
          @segment_map["e"] = bottom_left_segment.first
        end
      end
    end
  end

  def possibilities(digit)
    poss = [0,1,2,3,4,5,6,7,8,9]
    # process of elimination!
    if digit.length == 2
      return [1]
    elsif digit.length == 4
      return [4]
    elsif digit.length == 3
      return [7]
    elsif digit.length == 7
      return [8]
    else
      digits = digit.chars.sort
      poss = poss - [1,4,7,8]
      # quick determination if digits contains all segments in known things
      if @map[1] && (@map[1] - digits).empty?
        poss = poss - [2,5,6]
      end
      if @map[4] && (@map[4] - digits).empty?
        poss = poss - [0,1,2,3,5,6,7]
      end
      # digits does not contain known bottom left segment
      if @segment_map["e"] && ([@segment_map["e"]] - digits).empty?
        poss = poss - [1,3,4,5,7,9]
      end
    end
    poss
  end

  def translate_output
    output = []
    each_digit do |digit|
      if UNIQUE_LENGTHS.include?(digit.length)
        output.push(UNIQUE_LENGTH_MAP[digit.length])
      else
        output.push(digit)
      end
    end
    output
  end
end

readouts = lines.map do |line|
  OutputLine.new(line)
end

# ok lets count the uniques in all the outputs

all_uniques = 0
readouts.each do |output_line|
  all_uniques += output_line.unique_in_output
end

puts "answer to part 1: #{all_uniques}"

# OK NOW TIME TO DEDUCE LOL.

# focusing on one line at a time.

readouts.first.print_info
