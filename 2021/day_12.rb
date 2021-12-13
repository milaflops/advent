#!/usr/bin/env ruby

require 'set'

example1 = <<~CAVES
start-A
start-b
A-c
A-b
b-d
A-end
b-end
CAVES
# that one has 10 paths

example2 = <<~CAAVES
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
CAAVES
# this one has 19 paths

example3 = <<~AAACAVES
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
AAACAVES
# this one has 226 paths through it

input = <<~CAVES
TR-start
xx-JT
xx-TR
hc-dd
ab-JT
hc-end
dd-JT
ab-dd
TR-ab
vh-xx
hc-JT
TR-vh
xx-start
hc-ME
vh-dd
JT-bm
end-ab
dd-xx
end-TR
hc-TR
start-vh
CAVES

DEBUG = false

def str_to_caves(string)
    cave_lookup = {}
    string.lines.each do |line|
        cave1, cave2 = line.strip.split("-")
        cave_lookup[cave1] ||= Set.new
        cave_lookup[cave1].add cave2
        cave_lookup[cave2] ||= Set.new
        cave_lookup[cave2].add cave1
    end
    cave_lookup
end

def caves_to_paths(caves)
    paths = []
    queue = [["start"]]
    while !queue.empty?
        next_path = queue.shift
        puts " ---- currently analyzing path: #{next_path.inspect}" if DEBUG
        visited = Set.new
        next_path.each do |stop|
            if stop == "start"
            elsif stop == stop.upcase
            else
                visited.add(stop)
            end
        end
        possibilities = caves[next_path.last].to_a
        puts "  --- these are our possibilities: #{possibilities}" if DEBUG
        possibilities.each do |possibility|
            puts "   -- #{possibility}" if DEBUG
            if possibility == "end"
                paths.push((next_path + [possibility]).join(","))
                puts "finished path: #{paths.last}" if DEBUG
            elsif possibility == "start"
                puts "not going back to start" if DEBUG
            elsif visited.include?(possibility)
                puts "already visited #{possibility}" if DEBUG
            else
                if possibility == possibility.downcase
                    visited.add(possibility)
                end
                queue.push(next_path + [possibility])
                puts "pushed this one into queue" if DEBUG
            end
        end
    end
    paths
end

puts "######## PART 1 ########"
[
    ["example 1", example1, 10],
    ["example 2", example2, 19],
    ["example 3", example3, 226],
    ["input", input, nil]
].each do |name,cavestring,expected_paths|
    hash = str_to_caves(cavestring)
    paths = caves_to_paths(hash)

    puts " ---- #{name}"
    puts "   -- expecting #{expected_paths} paths"
    puts "   -- got #{paths.length} paths"
end

def modified_pathfinder(caves)
    paths = []
    queue = [["start"]]
    small_caves = caves.keys.reject do |cave|
        (cave == "start") || 
        (cave == "end") ||
        (cave == cave.upcase)
    end
    puts small_caves
    while !queue.empty?
        next_path = queue.shift
        small_caves.each do |small_cave|
            # try making each small cave twice visitable
            # but, one ping only please
            puts " ---- currently analyzing path: #{next_path.inspect}" if DEBUG
            visited = {}
            next_path.each do |stop|
                if stop == "start"
                elsif stop == stop.upcase
                else
                    visited[stop] ||= 0
                    visited[stop] = 1
                end
            end
            possibilities = caves[next_path.last].to_a
            puts "  --- these are our possibilities: #{possibilities}" if DEBUG
            possibilities.each do |possibility|
                puts "   -- #{possibility}" if DEBUG
                if possibility == "end"
                    paths.push((next_path + [possibility]).join(","))
                    puts "finished path: #{paths.last}" if DEBUG
                elsif possibility == "start"
                    puts "not going back to start" if DEBUG
                elsif visited[possibility]
                    puts "already visited #{possibility}" if DEBUG
                else
                    if possibility == possibility.downcase
                        visited.add(possibility)
                    end
                    queue.push(next_path + [possibility])
                    puts "pushed this one into queue" if DEBUG
                end
            end
        end
    end
    paths
end

puts "######## PART 2 ########"
[
    ["example 1", example1, 36],
    ["example 2", example2, 103],
    ["example 3", example3, 3509],
    ["input", input, nil]
].each do |name,cavestring,expected_paths|
    hash = str_to_caves(cavestring)
    paths = modified_pathfinder(hash)

    puts " ---- #{name}"
    puts "   -- expecting #{expected_paths} paths"
    puts "   -- got #{paths.length} paths"
end