#!/usr/bin/env ruby

require 'colorize'

input = File.read("./inputs/day_9.txt")
map = input.split("\n").map do |row|
  row.chars.map do |digit|
    digit.to_i
  end
end

# find the local minima on this map!

def find_local_minima(map)
  minima = []
  map.each.with_index do |row,row_idx|

    row.each.with_index do |col,col_idx|
      search_indices = []
      # determine directions in which to search
      if row_idx == 0
        # we're in the top row
        search_indices.push :below
      elsif row_idx == map.length - 1
        # we're in the bottom row
        search_indices.push :above
      else
        # we're somewhere in the middle
        search_indices.push :above
        search_indices.push :below
      end
      if col_idx == 0
        # we're all the way on the left
        search_indices.push :right
      elsif col_idx == row.length - 1
        # we're all the way on the right
        search_indices.push :left
      else
        search_indices.push :right
        search_indices.push :left
      end
      # puts search_indices
      # puts col
      # start with assumption that we're at the lowest point,
      # and attempt to prove that's false with each check
      lowest = true
      search_indices.each do |direction|
        if direction == :above
          lowest = false if map[row_idx - 1][col_idx] <= col
        elsif direction == :below
          lowest = false if map[row_idx + 1][col_idx] <= col
        elsif direction == :left
          lowest = false if map[row_idx][col_idx - 1] <= col
        elsif direction == :right
          lowest = false if map[row_idx][col_idx + 1] <= col
        else
          raise "wat"
        end
      end
      if lowest
        print "#{col}".red
        minima.push col
      else
        print "#{col}".green
      end
    end
    puts
  end
  minima
end

# leaning hard into this semantics thing

risk_scores = find_local_minima(map).map do |score|
  score + 1
end

puts risk_scores.inspect

combined_risk_score = risk_scores.inject(:+)

puts "Answer to part 1: #{combined_risk_score}"

def posturize(map)
  # turn all 9s into :M and everything else into :B
  # (mountain and basin, idk)
  map.map do |row|
    row.map do |col|
      if col == 9
        :M
      else
        :B
      end
    end
  end
end

def finished_marking?(map)
  # test to see if every basin has been marked with a region code
  map.each do |row|
    row.each do |col|
      return false if col == :B
    end
  end
  true
end

def zero_mountains(map)
  map.map do |row|
    row.map do |col|
      col == :M ? 0 : col
    end
  end
end

# lol this is gonna use a lot of memorey doing it recursively
def mark_basins(map,marker=1)
  new_map = map.map do |row|
    row.dup
  end
  queue = []
  # fuck recursive bfs, we're using a queueue
  # first, find a basin cell to start with
  map.each.with_index do |row,row_idx|
    row.each.with_index do |col,col_idx|
      if col == :B
        queue.push [row_idx,col_idx]
        break
      end
    end
    break unless queue.empty?
  end
  
  while !queue.empty?
    row_idx, col_idx = queue.shift
    # puts "now searching #{row_idx}, #{col_idx}"
    # mark the initial one
    new_map[row_idx][col_idx] = marker
    search_indices = []
    # determine directions in which to search
    if row_idx == 0
      # we're in the top row
      search_indices.push :below
    elsif row_idx == map.length - 1
      # we're in the bottom row
      search_indices.push :above
    else
      # we're somewhere in the middle
      search_indices.push :above
      search_indices.push :below
    end
    if col_idx == 0
      # we're all the way on the left
      search_indices.push :right
    elsif col_idx == map.first.length - 1
      # we're all the way on the right
      search_indices.push :left
    else
      search_indices.push :right
      search_indices.push :left
    end
    # now let's conditionally add these directions to the queueue
    search_indices.each do |direction|
      if direction == :above
        if new_map[row_idx - 1][col_idx] == :B
          queue.push([row_idx-1,col_idx])
        end
      elsif direction == :below
        if new_map[row_idx + 1][col_idx] == :B
          queue.push([row_idx+1,col_idx])
        end
      elsif direction == :left
        if new_map[row_idx][col_idx - 1] == :B
          queue.push([row_idx,col_idx-1])
        end
      elsif direction == :right
        if new_map[row_idx][col_idx + 1] == :B
          queue.push([row_idx,col_idx+1])
        end
      else
        raise "wat"
      end
    end
  end
  if finished_marking?(new_map)
    return zero_mountains(new_map)
  else
    return mark_basins(new_map,marker+1)
  end
end

marked = mark_basins(posturize(map))

# print a pretty ascii thing of the map
marked.each do |row|
  row.each do |col|
    print "%3i" % col
  end
  puts
end

basin_sizes = {}

marked.each do |row|
  row.each do |basin|
    # basin of 0 is the null basin
    unless basin == 0
      basin_sizes[basin] ||= 0
      basin_sizes[basin] += 1
    end
  end
end

sorted_basins = basin_sizes.to_a.sort_by do |basin,size|
  size * -1
end

sorted_basins.take(3).each do |basin,size|
  puts "region #{basin} is #{size} big"
end

puts "multiply the three largest together and you get:"

product = sorted_basins.take(3).map do |basin,size|
  size
end.inject(:*)

puts "the answer to part 2: #{product}"