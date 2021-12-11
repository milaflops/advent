#!/usr/bin/env ruby

require 'colorize'

example = <<~SQUID
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
SQUID

require 'byebug'

input = File.read("./inputs/day_10.txt")
# octopi = input.split("\n").map do |line|
#     line.chars.each do |energy_level|

#     end
# end

# class Octopus
#     attr_reader :energy_level, :adjacents

#     def initialize(energy_level)
#         @energy_level = energy_level.to_i
#     end

#     def push_adjacents(adjacents)
#         @adjacents ||= []
#         adjacents.each do |adjacent|
#             unless adjacent.nil?
#                 @adjacents.push adjacent
#             end
#         end
#         # puts @adjacents.length
#     end
# end

# example_octopi = example.lines.map do |line|
#     line.strip.chars.map do |energy_level|
#         Octopus.new(energy_level)
#     end
# end

# example_octopi.each.with_index do |row,row_idx|
#     row.each.with_index do |octopus,col_idx|
#         unless row_idx == 0
#             octopus.push_adjacents([
#                 example_octopi[row_idx-1][col_idx-1],
#                 example_octopi[row_idx-1][col_idx],
#                 example_octopi[row_idx-1][col_idx+1]
#             ])
#         end
#         octopus.push_adjacents([
#             example_octopi[row_idx][col_idx-1],
#             example_octopi[row_idx][col_idx+1]
#         ])
#         unless row_idx == example_octopi.length - 1
#             octopus.push_adjacents([
#                 example_octopi[row_idx+1][col_idx-1],
#                 example_octopi[row_idx+1][col_idx],
#                 example_octopi[row_idx+1][col_idx+1]
#             ])
#         end
#     end
# end

# def print_octopi(octopi)
#     octopi.each do |row|
#         row.each do |octopus|
#             print octopus.adjacents.length
#             byebug
#         end
#         puts
#     end
# end

# print_octopi(example_octopi)

example = <<~SQUID
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
SQUID

require 'byebug'

input = File.read("./inputs/day_10.txt")

example_octopi = example.lines.map do |line|
    line.strip.chars.map do |char|
        char.to_i
    end
end

def flashes_left?(octopi)
    octopi.each do |row|
        row.each do |cell|
            return true if cell > 9
        end
    end
    false
end

def step_once(octopi)
    new_octopi = octopi.map do |row|
        row.map do |octopus|
            octopus + 1
        end
    end
    first_flash = nil
    while flashes_left?(new_octopi) && !first_flash
        new_octopi.each.with_index do |row,row_idx|
            row.each.with_index do |octopus,col_idx|
                if new_octopi[row_idx][col_idx] > 9
                    # find the first flasher
                    # puts "#{row_idx},#{col_idx}"
                    first_flash = [row_idx,col_idx]
                end
                break if first_flash
            end
        end
        # puts "found the first flasher: #{first_flash.inspect}"
        ff_row , ff_col = first_flash
        new_octopi[ff_row][ff_col] = 0
        [
            [-1,-1],
            [-1,0],
            [-1,1],
            [0,-1],
            [0,1],
            [1,-1],
            [1,0],
            [1,1]
        ].each do |rdelt,cdelt|
            # if new_octopi[ff_row+rdelt]
            #     unless new_octopi[ff_row+rdelt][ff_col+cdelt].nil?
            # ensure row is within bounds
            if ((ff_row + rdelt) >= 0) && ((ff_row + rdelt) < (new_octopi.length))
                if ((ff_col + cdelt) >= 0) && ((ff_col + cdelt) < (new_octopi.first.length))
                    unless new_octopi[ff_row+rdelt][ff_col+cdelt] == 0
                        # puts "setting #{ff_row+rdelt}#{ff_row+cdelt}"
                        new_octopi[ff_row+rdelt][ff_col+cdelt] += 1
                    end
                end
            end
            # end
        end
        first_flash = nil
    end
    new_octopi
end

def step_n_times(n,octopi)
    new_octopi = octopi
    n.times do |i|
        new_octopi = step_once(new_octopi)
        puts " ---- after #{i+1} times:"
        print_map(new_octopi)
    end
    new_octopi
end

def print_map(octopi)
    octopi.each do |row|
        row.each do |octopus|
            if octopus == 0
                print octopus.to_s.green
            else
                print octopus.to_s.blue
            end
        end
        puts
    end
end

# print_map(example_octopi)
# puts '---'
# print_map(step_once(step_once(example_octopi)))

step_n_times(8,example_octopi)