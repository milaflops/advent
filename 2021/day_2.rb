#!/usr/bin/env ruby

input = File.read("./inputs/day_2.txt")

lines = input.split("\n")

# part 1

depth = 0
horiz = 0

lines.each do |line|
    stuff = line.split(" ")
    command = stuff[0]
    scalar = stuff[1].to_i

    puts "MOVING #{command} #{scalar.inspect}"

    if command == "forward"
        horiz += scalar
    elsif command == "down"
        depth += scalar
    elsif command == "up"
        depth -= scalar
    else
        raise "AAAA UNRECOGNIZED COMMAND #{command}"
    end
end

puts "horiz: #{horiz} depth: #{depth}"

answer = horiz * depth
puts "answer: #{answer}"

# part 2

depth = 0
horiz = 0
aim = 0

lines.each do |line|
    stuff = line.split(" ")
    command = stuff[0]
    scalar = stuff[1].to_i

    puts "MOVING #{command} #{scalar.inspect}"

    if command == "forward"
        horiz += scalar
        depth += (aim * scalar)
    elsif command == "down"
        aim += scalar
    elsif command == "up"
        aim -= scalar
    else
        raise "AAAA UNRECOGNIZED COMMAND #{command}"
    end
end

puts "horiz: #{horiz} depth: #{depth}"

answer = horiz * depth
puts "Part 2 answer: #{answer}"
