class Rover
    #orientation => coordinate change expression to process M command
    MOVEMENTS = {
        :N => '@y += 1',
        :S => '@y -= 1',
        :E => '@x += 1',
        :W => '@x -= 1'
    }

    #mapping of post direction change orientation
    #based on current orientation 
    ORIENTATION = {
        :N => {:L => :W, :R => :E},
        :S => {:L => :E, :R => :W},
        :E => {:L => :N, :R => :S},
        :W => {:L => :S, :R => :N}
    }

    attr_reader :x, :y, :orientation
    def initialize(x, y, orient)
        @x = x
        @y = y
        @orientation = orient.to_sym
    end

    def process_commands(commands)
        commands.scan(/\w/).each {|cm| process_command(cm)}
    end

    def to_string
        "x: #{@x}, y: #{@y}, orientation: #{@orientation}"
    end

    private

    def process_command(command)
        if command == 'M'
            eval MOVEMENTS[@orientation]
        elsif command == 'L' or command == 'R' 
            @orientation = ORIENTATION[@orientation][command.to_sym]
        else
            raise "#{command} is not a valid command!"
        end
    end
end



