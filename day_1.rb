#!/usr/bin/env ruby

DEBUG = false

# a list of depths as read by sonar as we descend to the sea floor
input = File.read("./inputs/day_1.txt")

ary = input.split("\n").map do |string|
    string.to_i
end

# part 1: count increments from previous readout

incs = 0
last_measurement = -1

ary.each do |measurement|
    if last_measurement == -1
        puts " ---- First Line!" if DEBUG
    elsif measurement > last_measurement
        incs += 1
        puts "#{measurement} ---- Increased to #{incs} !" if DEBUG
    else
        puts "#{measurement} ---- Decreased." if DEBUG
    end
    last_measurement = measurement
end

puts "Part 1 answer: #{incs}"

# part 2: count increments of moving 3-measurement window

incs = 0
last_measurement = -1

ary.each.with_index do |measurement,index|
    unless ary[index+2]
        # last window
        break
    end
    sum = ary[index] + ary[index+1] + ary[index+2]
    print "#{ary[index]} + #{ary[index+1]} + #{ary[index+2]} = #{sum}" if DEBUG

    if last_measurement == -1
        puts " ---- First sum!" if DEBUG
    elsif sum > last_measurement
        incs += 1
        puts " ---- Increased to #{incs}!" if DEBUG
    else
        puts " ---- Decreased." if DEBUG
    end
    last_measurement = sum
end

puts "Part 2 answer: #{incs}"
