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
    return board if bingo?(board)
  end
  nil
end

def bingo?(board)
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

def print_board(board)
  board.each do |row|
    row.each do |cell|
      print "%2i " % (cell || 0)
    end
    puts
  end
end

# solv the bingo by MUTATING THE CELLS TO NEGATIVE, to mark them

found_first_winning = false
tripwire = false
last_losing_board = []

numbers_to_draw.each do |number_drawn|
  if tripwire
    last_losing_board.map! do |row|
      row.map do |cell|
        if cell == number_drawn
          nil
        else
          cell
        end
      end
    end
    if bingo?(last_losing_board)
      sum = 0
      last_losing_board.each do |row|
        row.each do |cell|
          sum += (cell || 0)
        end
      end
      puts "sum: #{sum}"
      puts "number just drawn: #{number_drawn}"
      product = sum * number_drawn
      puts "product: #{product}"
    end
  end
    # merely test if our last board has won
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
    # first winning board is marked and such
    if winning_board = find_winning_board(boards)
      unless found_first_winning
        puts " ==== found the first winner!"
        print_board(winning_board)
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
        found_first_winning = true
      end
      # break
    end
    # let's keep goin!!!!
    # boards_that_win = 0
    # boards_total = boards.length
    # boards.each do |board|
    #   if bingo?(board)
    #     boards_that_win += 1
    #   end
    # end
    # if boards_that_win + 1 == boards_total
    #   puts "one losing board left! let's calculate its score"
    #   losing_board = boards.select do |board|
    #     !bingo?(board)
    #   end
    # end
    losing_boards = boards.select do |board|
      !bingo?(board)
    end
    if losing_boards.length == 1
      puts " ==== we found the last loser!"
      puts " ---- setting tripwire until it wins"
      tripwire = true
      # print_board(losing_boards.first)
      # sum = 0
      # losing_boards.first.each do |row|
      #   row.each do |cell|
      #     sum += (cell || 0)
      #   end
      # end
      # puts "sum: #{sum}"
      # puts "number just drawn: #{number_drawn}"
      # product = sum * number_drawn
      # puts "product: #{product}"
      # exit
    end
  end
end
