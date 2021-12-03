#!/usr/bin/env ruby

# Solution to Day 3 using Monte Carlo sampling with interpolation

# TODO: metropolization

input = File.read("./inputs/day_3.txt")
$lines = input.split("\n")

DEBUG = false

# part 1

# one sample per discrete row to determine exact value? what nonsense!
def averaged_column(x)
    # x = bit position

    number_of_ones = 0
    total = 0

    $lines.each do |line|
        if line[x] == "1"
            number_of_ones +=1
        end
        total += 1
    end

    number_of_ones.to_f / total
end

def monte_carlo_sample(x,y)
    # x = index, basically.
    # y = 0-1 scales to 0-len of $lines

    # so... for a $lines length of 1,000
    # 0 => 0
    # 1 => 999
    line_number = y * ($lines.length - 1)

    puts "line number: #{line_number}" if DEBUG

    # we'll almost certainly be interpolating here!
    # if, perchance, line_number is a perfect int, it'll just average the same line
    prev_line = line_number.floor
    next_line = line_number.ceil
    # weight is how much the next_line contributes to the final value
    weight = line_number % 1

    puts "prev line: #{prev_line} next line: #{next_line} weight: #{weight}" if DEBUG

    prev_value = $lines[prev_line][x].to_i
    next_value = $lines[next_line][x].to_i

    puts "prev_value: #{prev_value} next_value: #{next_value}" if DEBUG

    final_sample = (prev_value * (1 - weight)) + (next_value * weight)

    puts "final sample: #{final_sample}" if DEBUG
    final_sample
end

def many_samples(x,number)
    sum = 0.0
    number.times do
        sum += monte_carlo_sample(x,rand)
    end
    sum / number
end

# puts monte_carlo_sample(0,0.6666)

[
    # 10,
    # 100,
    # 1_000,
    # 10_000,
    # 100_000,
    # 1_000_000,
    # 10_000_000,
].each do |samples|
    # position = rand(0..11)
    position = 0
    puts " ----"
    puts "Position: #{position}"
    puts "(with #{samples} samples)"
    exact_value = averaged_column(position)
    puts "exact value: #{exact_value}"
    sampled_value = many_samples(position, samples)
    puts "sampled value: #{sampled_value}"
end

final_bit_ary = []
samples = 1_000

puts "actual gamma rate, for reference:"
puts "000010111110"

[
    10,
    100,
    1_000,
    10_000,
    100_000,
    1_000_000,
    10_000_000,
].each do |samples|
    # actually find out the answer lmao
    final_answer = (0..11).to_a.map do |position|
        (many_samples(position,samples)).round
    end.join("")

    puts "#{final_answer} (with #{samples} samples per position)"
end