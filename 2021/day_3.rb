#!/usr/bin/env ruby

input = File.read("./inputs/day_3.txt")

lines = input.split("\n")

# part 1

ones = []
total = 0

lines.each.with_index do |bin_line|
    bin_line.chars.each.with_index do |char,index|
        if char == "0"
            # nothing!
        elsif char == "1"
            ones[index] ||= 0
            ones[index] += 1
        else
            raise "AAAAAAAsdsf"
        end
    end
    total += 1
end

puts ones.inspect
puts total

gamma_rate_bin = ones.map.with_index do |one,index|
    if ones[index] > (total / 2)
        "1"
    else
        "0"
    end
end.join("")

puts gamma_rate_bin
gamma_rate = gamma_rate_bin.to_i(2)
puts gamma_rate

epsilon_rate_bin = gamma_rate_bin.chars.map do |char|
    if char == "1"
        "0"
    elsif char == "0"
        "1"
    end
end.join("")

epsilon_rate = epsilon_rate_bin.to_i(2)

puts epsilon_rate

part_1_answer = gamma_rate * epsilon_rate
puts "Part 1 answer: #{part_1_answer}"

# part 2

def find_most_common(array, pos=0)
    puts "    ---- "
    puts "Finding most common in array of #{array.length}, pos #{pos}"
    puts array.inspect
    number_of_zeros = 0
    number_of_ones = 0
    array.each do |line|
        if line[pos] == "0"
            number_of_zeros += 1
        elsif line[pos] == "1"
            number_of_ones += 1
        end
    end

    puts "number of 0s: #{number_of_zeros}"
    puts "number of 1s: #{number_of_ones}"

    if number_of_zeros > number_of_ones
        most_common = "0"
    elsif number_of_ones > number_of_zeros
        most_common = "1"
    else
        most_common = "1"
    end

    reduced_array = array.select do |line|
        line[pos] == most_common
    end

    if reduced_array.length == 1
        return reduced_array.first
    else
        return find_most_common(reduced_array, pos+1)
    end
end

def find_least_common(array, pos=0)
    puts "    ---- "
    puts "Finding least common in array of #{array.length}, pos #{pos}"
    puts array.inspect
    number_of_zeros = 0
    number_of_ones = 0
    array.each do |line|
        if line[pos] == "0"
            number_of_zeros += 1
        elsif line[pos] == "1"
            number_of_ones += 1
        end
    end

    if number_of_zeros > number_of_ones
        least_common = "1"
    elsif number_of_ones > number_of_zeros
        least_common = "0"
    else
        least_common = "0"
    end

    puts "number of 0s: #{number_of_zeros}"
    puts "number of 1s: #{number_of_ones}"

    reduced_array = array.select do |line|
        line[pos] == least_common
    end

    if reduced_array.length == 1
        return reduced_array.first
    else
        return find_least_common(reduced_array, pos+1)
    end
end

oxygen_gen_bin = find_most_common(lines)
puts oxygen_gen_bin
oxygen_gen = oxygen_gen_bin.to_i(2)

co2_scrubber_bin = find_least_common(lines)
puts co2_scrubber_bin
co2_scrubber = co2_scrubber_bin.to_i(2)

life_support = oxygen_gen * co2_scrubber

puts "Part 2 answer: #{life_support}"
