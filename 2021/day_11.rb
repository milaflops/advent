#!/usr/bin/env ruby

require 'colorize'
require 'byebug'

input = File.read("./inputs/day_11.txt")
octopi = input.split("\n").map do |line|
    line.strip.chars.map do |energy_level|
        energy_level.to_i
    end
end

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

def count_flashed(octopi)
    sum = 0
    octopi.each do |row|
        row.each do |octopi|
            sum += 1 if octopi == 0
        end
    end
    sum
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
    flashes = 0
    n.times do |i|
        new_octopi = step_once(new_octopi)
        flashes += count_flashed(new_octopi)
        puts " ---- after #{i+1} times:"
        print_map(new_octopi)
        puts "    (#{flashes} flashes so far)"
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

step_n_times(100,octopi)

def count_until_all_flash(octopi)
    number_of_octopi = octopi.length * octopi.first.length
    new_octopi = octopi
    step = 0
    while true
        step += 1
        new_octopi = step_once(new_octopi)
        flashes = count_flashed(new_octopi)
        percent = ((flashes.to_f / number_of_octopi) * 100).round
        puts " ---- on step #{step}, #{percent} flashed"
        if flashes == number_of_octopi
           puts "done! they all flashed on step #{step}"
           break
        end
    end
end

count_until_all_flash(octopi)