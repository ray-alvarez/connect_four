require "connect_four"

describe ConnectFour do
    subject(:my_game) { ConnectFour.new }

    describe "attributes" do

        context "with game instance created" do
            it { is_expected.to respond_to(:current_player) }
            it { is_expected.to respond_to(:row_counter) }
            it { is_expected.to respond_to(:board) }
        end

    end

    describe "potential_lines" do

       context "when given a starting token" do 

            it "returns an array of possible lines" do
                expect(my_game.potential_lines([3, 4])).to be_instance_of(Array)
            end
        end
    end

    describe "place_checker" do

        context "when given '5' as location 2 times" do

            it "'@board[[4, 0]]' and '@board[[4, 1]]' are an instance of the struct 'Checker'" do
                my_game.place_checker(5)
                my_game.place_checker(5)
                expect(my_game.board[[4, 0]]).to be_instance_of(ConnectFour::Checker)
                expect(my_game.board[[4, 1]]).to be_instance_of(ConnectFour::Checker)
            end
        end

    end

    describe "next_turn" do

        context "when called" do

            it "changes @current_player value" do
                my_game.next_turn
                expect(my_game.current_player).to eql("Black")
            end
        end
    end

    describe "check_input" do

        context "when given a valid input" do

            it "returns it" do

                expect(my_game.check_input(5)).to satisfy { |num| num.between?(1, 7) }
            end
        end
    end

    describe "valid_row?" do
        
        context "when given an invalid row" do

            it "returns 9" do

                expect(my_game.valid_row?(20)).to eql(9)
            end
        end
    end

    describe "out_of_bounds?" do

        context "when given a line with an out of bounds location" do

            it "returns true" do

                expect(my_game.out_of_bounds?([[3, 5], [3, 6], [3, 7], [3, 8]])).to eql(true)
            end
        end
    end

    describe "player_won?" do

        context "when given winning conditions" do

            it "returns true" do
                my_game.board[[6, 0]] = ConnectFour::Checker.new(my_game.current_player)
                my_game.board[[6, 1]] = ConnectFour::Checker.new(my_game.current_player)
                my_game.board[[6, 2]] = ConnectFour::Checker.new(my_game.current_player)
                my_game.board[[6, 3]] = ConnectFour::Checker.new(my_game.current_player)
                expect(my_game.player_won?).to eql(true)
            end
        end
    end
end