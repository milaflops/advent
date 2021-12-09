#!/usr/bin/env ruby

linefmt = Struct.new :letter, :min, :max, :password

lines = File.read("./inputs/day_3.txt").split("\n")

# count trees going 3 across and 1 down forever

trees = 0

x = 0
y = 0

while lines[y]
  if lines[y][x] == "#"
    trees += 1
  end
  x += 3
  x = x % lines.first.length
  y += 1
end

puts "answer to part 1: there are #{trees} trees in the path"

trees_encountered = [
  [1,1],
  [3,1],
  [5,1],
  [7,1],
  [1,2]
].map do |x_delt, y_delt|
  trees = 0

  x = 0
  y = 0

  while lines[y]
    if lines[y][x] == "#"
      trees += 1
    end
    x += x_delt
    x = x % lines.first.length
    y += y_delt
  end
  trees
end

product = trees_encountered.inject(:*)

puts "answer to part 2: #{product}"