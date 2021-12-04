#!/usr/bin/env ruby

input = File.read("./inputs/day_4.txt")
lines = input.split("\n")

# parse the data

numbers_to_draw = lines[0].split(",").map do |number|
  number.to_i
end

boards = []
current_board = []

lines.each.with_index do |line,index|
  next if index == 0
  next if index == 1
  puts line
  if line == ""
    boards.push current_board
    current_board = []
  else
    numbers = line.split(" ").map do |number|
      number.to_i
    end
    current_board.push numbers
  end
end

# puts numbers_to_draw.inspect
# puts boards.inspect

def find_winning_board(boards)
  boards.each do |board|
    return board if board_wins?(board)
  end
  nil
end

def board_wins?(board)
  # test each row for straight nils
  board.each do |row|
    non_nils = 0
    row.each do |cell|
      non_nils += 1 unless cell.nil?
    end
    return true if non_nils == 0
  end
  # test each column for straight nils
  # (assuming )
  board.first.length.times do |col_idx|
    non_nils = 0
    board.each do |row|
      unless row[col_idx].nil?
        non_nils += 1
      end
    end
    return true if non_nils == 0
  end
  return false
end

# solv the bingo by MUTATING THE CELLS TO NEGATIVE, to mark them

numbers_to_draw.each do |number_drawn|
  # remove this number on every board
  boards.map! do |board|
    board.map do |row|
      row.map do |cell|
        if cell == number_drawn
          nil
        else
          cell
        end
      end
    end
  end
  if winning_board = find_winning_board(boards)
    puts "found one"
    winning_board.each do |row|
      row.each do |cell|
        print "%2i " % (cell || 0)
      end
      puts
    end
    sum = 0
    winning_board.each do |row|
      row.each do |cell|
        sum += (cell || 0)
      end
    end
    puts "sum: #{sum}"
    puts "number just drawn: #{number_drawn}"
    product = sum * number_drawn
    puts "product: #{product}"
    break
  end
  # # test each board to see if it wins
  # boards.each do |board|
  #   # begin with assumption that board wins until proven otherwise
  #   wins = true
  #   # test each row for positive numbers
  #   board.each do |row|
  #     row.each do |cell|
  #     end
  # end
end
