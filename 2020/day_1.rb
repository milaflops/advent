#!/usr/bin/env ruby
require 'set'

input = File.read("./inputs/day_1.txt")

entries = input.split("\n").map do |item|
    item.to_i
end

lookup = Set.new(entries)

# part 1

entries.each do |entry|
    diff = 2020 - entry
    if entries.include?(diff)
        puts "entry: #{entry} diff: #{diff}"
        mult = entry * diff
        puts "Part 1 answer: #{mult}"
        break
    end
end

# part 2

entries.each do |first_entry|
    entries.each do |second_entry|
        diff = 2020 - first_entry - second_entry
        if entries.include?(diff)
            puts "first entry: #{first_entry} second entry: #{second_entry} diff: #{diff}"
            mult = first_entry * second_entry * diff
            puts "Part 2 answer: #{mult}"
            break
        end
    end
end
