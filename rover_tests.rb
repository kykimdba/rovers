#!/usr/bin/ruby

require 'test/unit'
require './rover'
require './rover_controller'
require 'test/unit/ui/console/testrunner'

class RoverTests < Test::Unit::TestCase
    def test_bad_command_should_raise
        rover = Rover.new(1, 1, 'N')
        assert_raise(RuntimeError) {rover.process_commands "LRLRMH"}
    end

    def test_process_turn_left_from_north_should_be_west
        rover = Rover.new(1, 1, 'N')
        rover.process_commands "L"
        assert_equal(:W, rover.orientation)
    end

    def test_process_turn_right_from_north_should_be_east
        rover = Rover.new(1, 1, 'N')
        rover.process_commands "R"
        assert_equal(:E, rover.orientation)
    end

    def test_process_turn_left_from_east_should_be_north
        rover = Rover.new(1, 1, 'E')
        rover.process_commands "L"
        assert_equal(:N, rover.orientation)
    end

    def test_process_turn_right_from_east_should_be_south
        rover = Rover.new(1, 1, 'E')
        rover.process_commands "R"
        assert_equal(:S, rover.orientation)
    end

    def test_process_turn_left_from_south_should_be_east
        rover = Rover.new(1, 1, 'S')
        rover.process_commands "L"
        assert_equal(:E, rover.orientation)
    end

    def test_process_turn_right_from_south_should_be_west
        rover = Rover.new(1, 1, 'S')
        rover.process_commands "R"
        assert_equal(:W, rover.orientation)
    end

    def test_process_turn_left_from_west_should_be_south
        rover = Rover.new(1, 1, 'W')
        rover.process_commands "L"
        assert_equal(:S, rover.orientation)
    end

    def test_process_turn_right_from_west_should_be_north
        rover = Rover.new(1, 1, 'W')
        rover.process_commands "R"
        assert_equal(:N, rover.orientation)
    end

    def test_process_multiple_commands
        rover = Rover.new(1, 1, 'N')
        rover.process_commands "RMLMMRMLLM"
        assert_equal(:W, rover.orientation)
        assert_equal(2, rover.x)
        assert_equal(3, rover.y)
    end

    def test_process_empty_command
        rover = Rover.new(1, 1, 'N')
        rover.process_commands ""
        assert_equal(:N, rover.orientation)
        assert_equal(1, rover.x)
        assert_equal(1, rover.y)
    end

    def test_process_commands_move_north
        rover = Rover.new(1, 1, 'N')
        rover.process_commands "MM"
        assert_equal(1, rover.x)
        assert_equal(3, rover.y)
        assert_equal(:N, rover.orientation)
    end

    def test_process_commands_move_south
        rover = Rover.new(1, 1, 'S')
        rover.process_commands "M"
        assert_equal(1, rover.x)
        assert_equal(0, rover.y)
        assert_equal(:S, rover.orientation)
    end

    def test_process_commands_move_west
        rover = Rover.new(1, 1, 'W')
        rover.process_commands "MMM"
        assert_equal(-2, rover.x)
        assert_equal(1, rover.y)
        assert_equal(:W, rover.orientation)
    end

    def test_process_commands_move_east
        rover = Rover.new(1, 1, 'E')
        rover.process_commands "MMM"
        assert_equal(4, rover.x)
        assert_equal(1, rover.y)
        assert_equal(:E, rover.orientation)
        
    end
end

Test::Unit::UI::Console::TestRunner.run(RoverTests)

class RoverControllerTests < Test::Unit::TestCase

    def test_coding_challenge
        test_inputs = [
            "5 5",
            "1 2 N",
            "LMLMLMLMM",
            "3 3 E",
            "MMRMMRMRRM"
        ]
        r_controller = RoverController.new(test_inputs)
        expected_moved_rovers = [
            Rover.new(1, 3, 'N'),
            Rover.new(5, 1, 'E')
        ]

        r_controller.run_commands
        assert_equal(expected_moved_rovers[0].x, r_controller.moved_rovers[0].x)
        assert_equal(expected_moved_rovers[0].y, r_controller.moved_rovers[0].y)
        assert_equal(expected_moved_rovers[0].orientation, r_controller.moved_rovers[0].orientation)

        assert_equal(expected_moved_rovers[1].x, r_controller.moved_rovers[1].x)
        assert_equal(expected_moved_rovers[1].y, r_controller.moved_rovers[1].y)
        assert_equal(expected_moved_rovers[1].orientation, r_controller.moved_rovers[1].orientation)
    end

    def test_plateau_coordinates_should_be_skipped_silently
        test_inputs = [
            "5 5",
            "0 0",
            "5 0",
            "0 5"
        ]
        r_controller = RoverController.new(test_inputs)
        r_controller.run_commands
        assert_equal([], r_controller.new_rovers)
        assert_equal([], r_controller.moved_rovers)
        assert_equal([], r_controller.unmoved_rovers)
    end

    def test_invalid_x_should_raise
        r_controller = RoverController.new(["X 5 N"])
        assert_raise(RuntimeError) {r_controller.run_commands}
    end

    def test_invalid_y_should_raise
        r_controller = RoverController.new(["5 Y N"])
        assert_raise(RuntimeError) {r_controller.run_commands}
    end

    def test_invalid_orientation_should_raise
        r_controller = RoverController.new(["5 5 T"])
        assert_raise(RuntimeError) {r_controller.run_commands}
    end

    def test_invalid_command_should_raise
        r_controller = RoverController.new(["XLMR"])
        assert_raise(RuntimeError) {r_controller.run_commands}
    end
end

Test::Unit::UI::Console::TestRunner.run(RoverControllerTests)



