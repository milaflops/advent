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

# class Cave
#     attr_reader :name
#     def initialize(string)
#         @name = string
#         if string == "start"
#             @type = :start
#         elsif string == "end"
#             @type = :end
#         elsif string == string.upcase
#             @type = :big
#         elsif string == string.downcase
#             @type = :small
#         end
#         @connections = Set.new
#     end

#     def connect(cave)
#         @connections.add(cave)
#     end

#     def inspect
#         "cave: #{name} connections: [" +
#         @connections.to_a.map do |connection|
#             connection.name
#         end.join(", ") + "]"
#     end
# end

def str_to_caves(string)
    cave_lookup = {}
    string.lines.each do |line|
        cave1, cave2 = line.strip.split("-")
        # puts "#{cave1} ? no, #{cave2}"
        # @cave1 = cave_lookup[cave1] || cave_lookup[cave1] = Cave.new(cave1)
        # @cave2 = cave_lookup[cave2] || cave_lookup[cave2] = Cave.new(cave2)
        # @cave1.connect(@cave2)
        # @cave2.connect(@cave1)
        cave_lookup[cave1] ||= Set.new
        cave_lookup[cave1].add cave2
        cave_lookup[cave2] ||= Set.new
        cave_lookup[cave2].add cave1
    end
    # puts cave_lookup.inspect
    cave_lookup
end

def caves_to_paths(caves)
    paths = []
    queue = [["start"]]
    i = 0
    traversed_paths = Set.new
    while !queue.empty?
        break if i > 50
        next_path = queue.shift
        puts "currently analyzing path: #{next_path.inspect}"
        visited = Set.new
        possibilities = caves[next_path.last].to_a
        possibilities.each do |possibility|
            if possibility == "end"
                paths.push((next_path + [possibility]).join(","))
            elsif possibility == "start"
                # do nothing
            elsif visited.include?(possibility)
                # do nothing
            elsif traversed_paths.include?("#{next_path.last}-#{possibility}")
                # do nothing
            else
                # puts "our possibility is #{possibility}"
                if possibility == possibility.downcase
                    visited.add(possibility)
                end
                queue.push(next_path + [possibility])
                traversed_paths.add("#{next_path.last}-#{possibility}")
            end
            # visited.add(possibility.downcase)
        end
        i += 1
    end
    paths
end

hash = str_to_caves(example1)

puts caves_to_paths(hash)