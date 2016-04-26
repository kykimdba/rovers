require './rover'

class RoverController

    attr_reader :moved_rovers , :new_rovers, :unmoved_rovers

    def initialize(inputs)
        @commands = inputs
        @new_rovers = []
        @moved_rovers = []
        @unmoved_rovers = []
    end

    def run_commands
        @commands.each do |com|
            #logic to distinguish commands is good enough for now
            #but may need to be improved
            command_params = com.split(" ")
            if command_params.length == 3
                raise "x coordinate must be numeric" if not command_params[0] =~ /\d/
                raise "y coordinate must be numeric" if not command_params[1] =~ /\d/
                acceptable = Rover::ORIENTATION.keys
                raise "orientation must be one of #{acceptable}" if not acceptable.include?(command_params[2].to_sym)
                @new_rovers << Rover.new(command_params[0].to_i, command_params[1].to_i, command_params[2])
            elsif command_params.length == 1
                raise "#{command_params[0]} includes invalid command" if command_params[0] =~ /[^LRM]/
                rover = @new_rovers.shift
                if rover != nil
                    begin
                        rover.process_commands(command_params[0])
                        @moved_rovers << rover
                    rescue RuntimeError => e
                        @unmoved_rovers << rover
                    end
                end
            end
        end             
    end
end

