#!/usr/bin/ruby
require './rover_controller'

test_inputs = [
    "5 5",
    "1 2 N",
    "LMLMLMLMM",
    "3 3 E",
    "MMRMMRMRRM"
]

begin
    r_controller = RoverController.new(test_inputs)
    r_controller.run_commands
    r_controller.moved_rovers.each {|rover| puts rover.to_string}
rescue RuntimeError => e
    puts "Not what was expected #{e.inspect}"
end
