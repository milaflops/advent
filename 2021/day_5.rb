#!/usr/bin/env ruby

input = File.read("./inputs/day_5.txt")
lines = input.split("\n")

Point = Struct.new :x, :y

class Segment
    attr_reader :start, :finish

    def initialize(start, finish)
        @start = start
        @finish = finish
    end

    def footprint
        points = []
        if horiz?
            if start.x < finish.x
                # goes from left to right
                (start.x..finish.x).each do |x|
                    points.push Point.new(x,start.y)
                end
            elsif start.x > finish.x
                # goes from right to left
                (finish.x..start.x).each do |x|
                    points.push Point.new(x,start.y)
                end
            end
        elsif vert?
            if start.y < finish.y
                # goes from top to bottom
                (start.y..finish.y).each do |y|
                    points.push Point.new(start.x,y)
                end
            elsif start.y > finish.y
                # goes from bottom to top
                (finish.y..start.y).each do |y|
                    points.push Point.new(start.x,y)
                end
            end
        else
            # oh boy, it's neither, but we still must count it!
            # there are four directions it could go.
            if start.x < finish.x
                # x increments
                if start.y < finish.y
                    # y increments
                    # NW => SE
                    # probably the easiest to take care of because both increment positively.
                    x = start.x
                    y = start.y
                    while x <= finish.x
                        points.push Point.new(x,y)
                        x += 1
                        y += 1
                    end
                elsif start.y > finish.y
                    # y decrements
                    # SW => NE
                    x = start.x
                    y = start.y
                    while x <= finish.x
                        points.push Point.new(x,y)
                        x += 1
                        y -= 1
                    end
                end
            elsif start.x > finish.x
                # x decrements
                if start.y < finish.y
                    # y increments
                    # NE => SW
                    x = start.x
                    y = start.y
                    while x >= finish.x
                        points.push Point.new(x,y)
                        x -= 1
                        y += 1
                    end
                elsif start.y > finish.y
                    # y decrements
                    # SE => NW
                    x = start.x
                    y = start.y
                    while x >= finish.x
                        points.push Point.new(x,y)
                        x -= 1
                        y -= 1
                    end
                end
            end
        end
        points
    end

    def horiz?
        start.y == finish.y
    end
    
    def vert?
        start.x == finish.x
    end

    def straight?
        horiz? || vert?
    end
end

max_x = 0
max_y = 0

segments = lines.map do |line|
    points = line.split " -> "
    point1 = points[0].split ","
    point2 = points[1].split ","
    point1 = Point.new point1[0].to_i, point1[1].to_i
    point2 = Point.new point2[0].to_i, point2[1].to_i
    max_x = [max_x,point1.x,point2.x].max
    max_y = [max_y,point1.y,point2.y].max
    Segment.new point1, point2
end

straight_segments = segments.select do |segment|
    segment.straight?
end

puts straight_segments.first

map = Array.new(max_y + 1) do
    Array.new(max_x + 1,nil)
end

# record footprint of straight segments
straight_segments.each do |seg|
    seg.footprint.each do |point|
        map[point.y][point.x] ||= 0
        map[point.y][point.x] += 1
    end
end

# count overlaps
straight_sum = 0

map.each do |row|
    row.each do |cell|
        if cell && (cell > 1)
            straight_sum += 1
        end
    end
end

puts "Part 1 answer (overlaps of straight segments): #{straight_sum}"

# reject the straights
diagonal_segments = segments.reject do |segment|
    segment.straight?
end

# record footprint of diagonal segments
diagonal_segments.each do |seg|
    seg.footprint.each do |point|
        map[point.y][point.x] ||= 0
        map[point.y][point.x] += 1
    end
end

# re-count overlaps
all_sum = 0

map.each do |row|
    row.each do |cell|
        if cell && (cell > 1)
            all_sum += 1
        end
    end
end

puts "Part 2 answer (overlaps of all segments): #{all_sum}"
