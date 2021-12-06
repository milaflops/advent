#!/usr/bin/env ruby

require 'pp'

input = File.read("./inputs/day_6.txt")

fish = input.split(",").map do |age|
    age.to_i
end

# part 1 is easy, part 2 gets too slow if you keep track of each fish.
# so instead of an array of individual fish, we've binned them into a hash like this:

# example_table = {
#     0: 1,
#     1: 3,
#     7: 2,
#     8: 9
# }

def gen_fish_table
    table = {}
    # populating it this way so it's ordered when printed
    (0..8).each do |age|
        table[age] = 0
    end
    table
end

def fish_to_table(fish)
    table = gen_fish_table
    # now let's collate them
    fish.each do |age|
        table[age] += 1
    end
    table
end

fish_table = fish_to_table(fish)

puts fish_table.inspect

def iterate_table_once(fishtable)
    new_fishtable = gen_fish_table
    fishtable.each do |age, freq|
        if age == 0
            new_fishtable[6] += freq
            new_fishtable[8] += freq
        else
            new_fishtable[age-1] += freq
        end
    end
    new_fishtable
end

def iterate_table_n_times(n,fishtable)
    new_fishtable = fishtable
    n.times do
        new_fishtable = iterate_table_once(new_fishtable)
    end
    new_fishtable
end

def count_table(fishtable)
    sum = 0
    fishtable.each do |_, freq|
        sum += freq
    end
    sum
end

after_80_times = iterate_table_n_times(80,fish_table)
puts "answer to part 1 (new method): #{count_table(after_80_times)}"

# puts iterate_table_once(fish_table).inspect

after_256_times = iterate_table_n_times(256,fish_table)
puts "answer to part 2 (new method): #{count_table(after_256_times)}"
