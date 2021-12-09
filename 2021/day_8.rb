#!/usr/bin/env ruby

require 'byebug'
require 'set'

input = File.read("./inputs/day_8.txt")
lines = input.split("\n").map

class OutputLine
  UNIQUE_LENGTHS = Set.new([2,3,4,7])

  def initialize(line)
    @raw_input, @raw_output = line.split(" | ")
    @input_digits = @raw_input.split(" ")
    @output_digits = @raw_output.split(" ")
    @map = (0..9).to_a.map do |digit|
      [digit, []]
    end.to_h
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

  def digits
    @input_digits + @output_digits
  end

  def output_value
    @output_digits.map do |digit|
      @seq_map[digit.chars.sort].to_s
    end.join.to_i
  end

  def each_digit
    (@input_digits + @output_digits).each do |sequence|
      yield sequence
    end
  end

  def intersection(chars1, chars2)
    # so if you feed this ["a", "b", "c"] and ["b", "c", "d"]
    # then you should get ["b", "c"]
    chars1.select do |char|
      chars2.include?(char)
    end
  end

  def build_map!
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
            @map[9] = seq
          elsif common_with_4.length == 3
            # it's 0
            @seq_map[seq] = 0
            @map[0] = seq
          else
            raise "shit"
          end
        elsif common_with_1.length == 1
          @seq_map[seq] = 6
          @map[6] = seq
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
        # 5
        # this digit has 1 in common with 1
        # this digit has 2 in common with 7
        # this digit has 3 in common with 4
        if common_with_1.length == 1
          # its 2 or 5
          if common_with_4.length == 2
            # it's 2
            @seq_map[seq] = 2
          elsif common_with_4.length == 3
            # it's 5
            @seq_map[seq] = 5
          end
        elsif common_with_1.length == 2
          # it's 3
          @seq_map[seq] = 3
        end
      end
    end
  end

  def translate_digit(seq)
    @seq_map[seq.chars.sort]
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

final_sum_of_outputs = readouts.map do |output_line|
  output_line.output_value
end.inject(:+)

puts "answer to part 2: #{final_sum_of_outputs}"
