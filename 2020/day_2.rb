#!/usr/bin/env ruby

linefmt = Struct.new :letter, :min, :max, :password

input = File.read("./inputs/day_2.txt")
database = input.split("\n").map do |line|
    match = line.match /^(\d+)-(\d+) ([a-z]): (.*)$/
    linefmt.new match[3], match[1].to_i, match[2].to_i, match[4]
end

# part 1

valid_passwords = 0

database.each do |row|
    count = 0
    row.password.chars.each do |char|
        count += 1 if char == row.letter
    end
    if count >= row.min
        if count <= row.max 
            valid_passwords += 1
        end
    end
end

puts "Part 1 valid passwords: #{valid_passwords}"

# part 2

valid_passwords = 0

database.each do |row|
    occurences = 0
    if row.password[row.min-1] == row.letter
        occurences += 1
    end
    if row.password[row.max-1] == row.letter
        occurences += 1
    end
    if occurences == 1
        valid_passwords += 1
    end
end

puts "Part 2 valid passwords: #{valid_passwords}"
