#!/usr/bin/env ruby

input = File.read("./inputs/day_2.txt")
lines = input.split("\n")

linefmt = Struct.new :letter, :min, :max, :password

valid_passwords = 0

lines.each do |line|
    match = line.match /^(\d+)-(\d+) ([a-z]): (.*)$/
    slop = linefmt.new match[3], match[1], match[2], match[4]
    count = 0
    slop.password.chars.each do |char|
        if char == slop.letter
            count += 1
        end
end

puts "AAAA"