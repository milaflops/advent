#!/usr/bin/env ruby

require 'colorize'



class Chunk
  POINTS = {
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  IPOINTS = {
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
  }

  COMPLETION_CHARS = {
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }

  def initialize(line)
    stack = []
    line.chars.each do |char|
      if char == "("
        stack.push "("
      elsif char == "["
        stack.push "["
      elsif char == "{"
        stack.push "{"
      elsif char == "<"
        stack.push "<"
      elsif char == ")"
        if stack.last == "("
          stack.pop
        else
          @corrupted = true
          @illegal_char = char
          break
        end
      elsif char == "]"
        if stack.last == "["
          stack.pop
        else
          @corrupted = true
          @illegal_char = char
          break
        end
      elsif char == "}"
        if stack.last == "{"
          stack.pop
        else
          @corrupted = true
          @illegal_char = char
          break
        end
      elsif char == ">"
        if stack.last == "<"
          stack.pop
        else
          @corrupted = true
          @illegal_char = char
          break
        end
      else
        raise "what the fuck is this: #{char}"
      end
      # unless stack.empty?
      #   @incomplete = true
      #   @stack = stack
      # end
      if @corrupted
      else
        @incomplete = true
        @stack = stack
      end
    end
  end

  def completion_string
    raise "no completion string" unless @incomplete
    @stack.map do |char|
      COMPLETION_CHARS[char]
    end.reverse.join
  end

  def corrupted?
    !!@corrupted
  end

  def incomplete?
    return false if @corrupted
    !!@incomplete
  end

  def info
    if @corrupted
      :corrupted
    elsif @incomplete
      :incomplete
    else
      :nothing
    end
  end

  def points
    if @illegal_char
      POINTS[@illegal_char]
    elsif @incomplete
      points_sum = 0
      # puts completion_string
      completion_string.chars.each do |char|
        # puts "start points_sum: #{points_sum}"
        points_sum *= 5
        # puts "  * 5 points_sum: #{points_sum}"
        points_sum += IPOINTS[char]
        # puts " + .. points_sum: #{points_sum}"
      end
      return points_sum
    else
      0
    end
  end
end

input = File.read("./inputs/day_10.txt")
# input = <<~NICE
# [({(<(())[]>[[{[]{<()<>>
# [(()[<>])]({[<{<<[]>>(
# (((({<>}<{<{<>}{[]{[]{}
# {<[[]]>}<{[{[{[]{()[[[]
# <{([{{}}[<[[[<>{}]]]>[]]
# NICE
chunks = input.split("\n").map do |line|
  Chunk.new(line)
end

chunks.each.with_index do |chunk,index|
  puts "#{index}:\t#{chunk.info}\t#{chunk.incomplete?}\t#{chunk.points}"
end

corrupted_points_sum = chunks.select do |chunk|
  chunk.corrupted?
end.map do |chunk|
  chunk.points
end.inject(:+)

puts "answer to part 1 (sum of points): #{corrupted_points_sum}"

incomplete_points = chunks.select do |chunk|
  chunk.incomplete?
end.map do |chunk|
  chunk.points
end.sort

puts "    ----"
puts incomplete_points
puts "    ----"

puts "incomplete_points length is #{incomplete_points.length}"

[
 -2,
 -1,
 0,
 1,
 2
].each do |nudge|
  calculated_middle = incomplete_points.length.to_i / 2
  middle = calculated_middle + nudge

  middle_score = incomplete_points[middle]

  puts "at idx #{middle}: #{middle_score}"
end

puts "middle score - 1:", incomplete_points[(incomplete_points.length.to_i / 2) - 1]
puts "middle score:", middle_score = incomplete_points[incomplete_points.length.to_i / 2]
puts "middle score + 1", incomplete_points[(incomplete_points.length.to_i / 2) + 1]

# puts incomplete_points

puts "answer to part 2, middle score of incomplete lines: #{middle_score}"
