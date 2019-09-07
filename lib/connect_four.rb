class ConnectFour
    attr_accessor :current_player, :row_counter, :board

    Checker = Struct.new(:color)

    def initialize
        @board = {}
        @player1 = "Red"
        @player2 = "Black"
        @current_player = @player1
        @row_counter = []
        7.times { @row_counter << 0 }
    end

    def potential_lines(initial_checker)
        x = initial_checker[0]
        y = initial_checker[1]
        possible_lines = []
        # Vertical lines
        line = [[x + 0, y + 0], [x + 0, y + 1], [x + 0, y + 2], [x + 0, y + 3]]
        possible_lines << line unless out_of_bounds?(line)
        # Horizontal lines
        line = [[x + 0, y + 0], [x + 1, y + 0], [x + 2, y + 0], [x + 3, y + 0]]
        possible_lines << line unless out_of_bounds?(line)
        # Diagonal lines
        line = [[x + 0, y + 0], [x + 1, y + 1], [x + 2, y + 2], [x + 3, y + 3]]
        possible_lines << line unless out_of_bounds?(line)
        # Reverse Diagonal line
        line = [[x + 0, y + 0], [x - 1, y + 1], [x - 2, y + 2], [x - 3, y + 3]]
        possible_lines << line unless out_of_bounds?(line)
        possible_lines
    end

    def start_game
        victory = false
        42.times do 
            puts "It's #{@current_player}'s turn"
            puts "Select a row"

            input = gets.chomp
            break if input == "exit"
            input = check_input(input[0])

            place_checker(input.to_i)

            print_board

            # search for winner if there are 7 tokens
            if @board.length >= 7
                if player_won?
                    victory = true
                    puts "Winner! #{@current_player} has won!"
                    break
                end
            end

            next_turn
        end
        puts "it's a draw!" unless victory
    end

    # create an instance of checkers in desired row
    # by utilizing the number of checkers on that row to find
    # the next available slot
    def place_checker(location)
        location -= 1
        x = location
        y = @row_counter[location]
        @board[[x, y]] = Checker.new(@current_player)
        @row_counter[location] += 1
    end

    def check_input(input)
        input = valid_row?(input.to_i)
        if input.to_i != (1..7)
            while !input.to_i.between?(1, 7)
                puts "Enter a number between 1 and 7"
                input = gets.chomp[0].to_i
                input = valid_row?(input)
            end
        end
        return input
    end

    # if the selected row is full changes the input to a wrong number
    # so the user is asked for a new input
    def valid_row?(row)
        if @row_counter[row - 1] == nil
            puts "Row invalid"
            return 9
        elsif @row_counter[row - 1] > 5
            puts "Row full"
            return 9
        else
            return row
        end
    end

    # prevent adding out of the board lines
    def out_of_bounds?(line)
        line.each do |location|
            return true unless location[0].between?(0, 6)
            return true unless location[1].between?(0, 5)
        end
        false
    end

    # print the board creating a new line at the end of each row
    def print_board
        6.times do |y|
            y = 5 - y 
            7.times do |x|
                if @board[[x, y]] == nil
                    x == 6 ? (puts "( )") : (print "( )")
                else
                    x ==  6 ? (puts "(#{@board[[x, y]].color[0, 3]})") : (print "(#{@board[[x, y]].color[0, 3]})")
                end
            end
        end
    end

    def next_turn
        @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
    end

    #Checks if any of the possible lines is all of the same color
    def player_won?
        victory = false
        @board.each do |key, value|
            victory = potential_lines(key).any? do |line|
                line.all? do |location|
                    next if @board[location] == nil
                    @board[location].color == @current_player
                end
            end
            return true if victory == true
        end
        false
    end

end

my_game = ConnectFour.new
my_game.start_game