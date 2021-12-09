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

INVERSE_SEGMENT_LOOKUP = REFERENCE_SEGMENTS.to_a.map do |digit,seq|
  [seq.chars.sort.join,digit]
end.to_h

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
  REF = "abcdefg".chars
  def initialize(line)
    @raw_input, @raw_output = line.split(" | ")
    @input_digits = @raw_input.split(" ")
    @output_digits = @raw_output.split(" ")
    @map = (0..9).to_a.map do |digit|
      [digit, []]
    end.to_h
    @segment_map = {}
    @poss_map = ("a".."g").to_a.map do |reference|
      [reference, "abcdefg".chars]
    end.to_h
    @attempts = 0
    @seq_map = {}
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
    puts @poss_map.inspect
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

  def intersection(chars1, chars2)
    # so if you feed this ["a", "b", "c"] and ["b", "c", "d"]
    # then you should get ["b", "c"]
    chars1.select do |char|
      chars2.include?(char)
    end
  end

  def possibilities_left?
    @attempts += 1
    return false if @attempts > 100
    @poss_map.each do |_,poss|
      return true if poss.length > 1
    end
    false
  end

  # def build_map!
  #   puts " ---- building map"
  #   while possibilities_left?
  #     # doing multiple passes!
  #     # let's get the known ones squared away
  #     each_digit do |seq|
  #       if UNIQUE_LENGTHS.include?(seq.length)
  #         # set map when we are sure of a digit
  #         @map[UNIQUE_LENGTH_MAP[seq.length]] = seq.chars
  #       end
  #       if seq.length == 2
  #         # this is 1 for sure
  #         # intentionally re-calling chars for free duplication
  #         @poss_map["c"] = intersection(@poss_map["c"], seq.chars)
  #         @poss_map["f"] = intersection(@poss_map["f"], seq.chars)
  #       elsif seq.length == 4
  #         @poss_map["b"] = intersection(@poss_map["b"], seq.chars)
  #         @poss_map["c"] = intersection(@poss_map["c"], seq.chars)
  #         @poss_map["d"] = intersection(@poss_map["d"], seq.chars)
  #         @poss_map["f"] = intersection(@poss_map["f"], seq.chars)
  #       elsif seq.length == 3
  #         @poss_map["a"] = intersection(@poss_map["a"], seq.chars)
  #         @poss_map["c"] = intersection(@poss_map["c"], seq.chars)
  #         @poss_map["f"] = intersection(@poss_map["f"], seq.chars)
  #       elsif seq.length == 6
  #         missing_segment = (REF - seq.chars).first
  #         if !@map[4].empty?
  #           if @map[4].include?(missing_segment)
  #             # if the missing segment is in "4", then the sequence is 0 or 6
  #             # if !@map[1].empty? 
  #             #   # let's only proceed if we've got possibilities calculated for 1 yet
  #             #   if @map[1].include?(missing_segment)
  #             #     # if the missing segment is in "1", then it's 6
  #             #     @poss_map["c"] = intersection(@poss_map["c"], seq.chars)
  #             #     @map[6] = seq.chars.sort
  #             #   else
  #             #     # if the missing segment is not in "1", then it's 0
  #             #     @poss_map["d"] = intersection(@poss_map["d"], seq.chars)
  #             #     @map[0] = seq.chars.sort
  #             #   end
  #             # end
  #           else
  #             # if the missing segment is not in "4", then the sequence is 9
  #             @poss_map["e"] = intersection(@poss_map["e"], [missing_segment])
  #             @map[9] = seq.chars.sort
  #             # and we know what the bottom segment is, because it's whatever's not in 1, 4, or 7
  #             if !@map[1].empty? && !@map[4].empty? && !@map[7].empty?
  #               @poss_map["g"] = intersection(@poss_map["g"], (REF - @map[4] - @map[7] - [missing_segment]))
  #             end
  #           end
  #         end
  #       elsif seq.length == 5
  #         # there are two missing segments! so it's either 2, 3, or 5
  #         missing_digits = REF - seq.chars
  #         if @map[4]
  #           common_with_4 = intersection(missing_digits, @map[4])
  #           if common_with_4.length == 2
  #             # if both are in 4, then it's 2
  #             @poss_map["b"] = intersection(@poss_map["b"], missing_digits)
  #             @poss_map["f"] = intersection(@poss_map["f"], missing_digits)
  #             @map[2] = seq.chars.sort
  #           end
  #         end
  #         # if @map[1]
  #         #   common_with_1 = intersection(missing_digits, @map[1])
  #         #   if common_with_1 ==
  #       else
  #         "nice"
  #       end
  #     end
  #     # figure out "a"
  #     if @map[1] && @map[7]
  #       @poss_map["a"] = @map[7] - @map[1]
  #     end
  #     # reduce "b" and "d"
  #     if @map[1] && @map[4]
  #       @poss_map["b"] = intersection(@poss_map["b"], (@map[4] - @map[1]))
  #       @poss_map["d"] = intersection(@poss_map["d"], (@map[4] - @map[1]))
  #     end
  #     # cull possibilities already determined from other possibilities
  #     confidences = []
  #     @poss_map.each do |ref,poss|
  #       if poss.length == 1
  #         puts "we are confident that #{ref} is #{poss.first}"
  #         confidences.push(poss.first)
  #       end
  #     end
  #     @poss_map = @poss_map.to_a.map do |ref,poss|
  #       if poss.length > 1
  #         [ref, poss - confidences]
  #       else
  #         [ref, poss]
  #       end
  #     end.to_h
  #   end

  def build_map!
    puts " ---- building map"
    # let's try this in one go, shall we?
    # get our confidence down:
    each_digit do |seq|
      seq = seq.chars.sort
      if seq.length == 2
        @seq_map[seq] = 1
        @map[1] = seq
      elsif seq.length == 4
        @seq_map[seq] = 4
        @map[4] = seq
      elsif seq.length == 3
        @seq_map[seq] = 7
        @map[7] = seq
      elsif seq.length == 7
        @seq_map[seq] = 8
        @map[8] = seq
      end
    end
    # we've got all the confident ones ruled out. now what?
    each_digit do |seq|
      seq = seq.chars.sort
      common_with_1 = intersection(seq, @map[1])
      common_with_4 = intersection(seq, @map[4])
      common_with_7 = intersection(seq, @map[7])
      if seq.length == 6
        # it's either 0, 6, or 9
        # 0
        # this digit has 2 in common with 1
        # this digit has 3 in common with 7
        # this digit has 3 in common with 4
        # 6
        # this digit has 1 in common with 1
        # this digit has 2 in common with 7
        # this digit has 3 in common with 4
        # 9
        # this digit has 2 in common with 1
        # this digit has 3 in common with 7
        # this digit has 4 in common with 4
        if common_with_1.length == 2
          if common_with_4.length == 4
            # it's 9
            @seq_map[seq] = 9
          elsif common_with_4 == 3
            # it's 0
            @seq_map[seq] = 0
          else
            # it's 6
            @seq_map[seq] = 6
          end
        end
      elsif seq.length == 5
        # it's either 2, 3, 5, or 6
        # 2
        # this digit has 1 in common with 1
        # this digit has 2 in common with 7
        # this digit has 2 in common with 4
        # 3
        # this digit has 2 in common with 1
        # this digit has 2 in common with 7
        # this digit has 3 in common with 4
        if common_with_1.length == 1
          if common_with_4.length == 2
            # it's 2
            @seq_map[seq] == 2
          end
        elsif common_with_1.length == 2
          # it's 3
          @seq_map[seq] == 3
        end
        # 5
        # this digit has 1 in common with 1
        # this digit has 2 in common with 7
        # this digit has 3 in common with 4
        # 6
        # this digit has 1 in common with 1
        # this digit has 2 in common with 7
        # this digit has 3 in common with 4
        # 5 and 6 will be indeterminable until we know the others, so we'll wait for a final pass
      end
    end
    puts @seq_map.inspect
  end

  # def possibilities(digit)
  #   poss = [0,1,2,3,4,5,6,7,8,9]
  #   # process of elimination!
  #   if digit.length == 2
  #     return [1]
  #   elsif digit.length == 4
  #     return [4]
  #   elsif digit.length == 3
  #     return [7]
  #   elsif digit.length == 7
  #     return [8]
  #   else
  #     digits = digit.chars.sort
  #     poss = poss - [1,4,7,8]
  #     # quick determination if digits contains all segments in known things
  #     if @map[1] && (@map[1] - digits).empty?
  #       poss = poss - [2,5,6]
  #     end
  #     if @map[4] && (@map[4] - digits).empty?
  #       poss = poss - [0,1,2,3,5,6,7]
  #     end
  #     # digits does not contain known bottom left segment
  #     if @segment_map["e"] && ([@segment_map["e"]] - digits).empty?
  #       poss = poss - [1,3,4,5,7,9]
  #     end
  #   end
  #   poss
  # end

  def translate_sequence(seq)
    if possibilities_left?
      raise "oops, not enough reduction!"
    end
    # translated_sequence = []
    # seq.chars.each do |segment|
    #   translated_sequence.push @poss_map[segment].first
    # end
    # translated_sequence.sort.join
    seq.chars.map do |segment|
      @poss_map[segment].first
    end.sort.join
  end

  def translate_digit(seq)
    # puts translate_sequence(seq)
    # INVERSE_SEGMENT_LOOKUP[translate_sequence(seq)]
    @seq_map[seq.chars.sort]
  end

  def translate_output
    output = []
    each_digit do |digit|
      # if UNIQUE_LENGTHS.include?(digit.length)
      #   output.push(UNIQUE_LENGTH_MAP[digit.length])
      # else
      #   output.push(digit)
      # end
      output.push translate_digit(digit)
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
