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
    end
    unless @corrupted
      @incomplete = true
      @stack = stack
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
    if corrupted?
      POINTS[@illegal_char]
    elsif incomplete?
      points_sum = 0
      completion_string.chars.each do |char|
        points_sum *= 5
        points_sum += IPOINTS[char]
      end
      return points_sum
    else
      0
    end
  end
end

input = File.read("./inputs/day_10.txt")
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

middle_score = incomplete_points[incomplete_points.length.to_i / 2]

puts "answer to part 2, middle score of incomplete lines: #{middle_score}"
