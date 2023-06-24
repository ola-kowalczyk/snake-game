require "curses"
require "gaminator"

class Snake
    def initialize
        @direction = "right"
        @head = Head.new(40, 15)
        @tail = Tail.new(
            [
                TailSegment.new(39, 15),
                TailSegment.new(38, 15),
                TailSegment.new(37, 15),
            ]
        )
    end

    def head
        @head
    end

    def tail
        @tail
    end 
    
    def change_direction(new_direction)
        @direction = new_direction
    end    

    def move
        if @direction == "right"
            @head.x = @head.x + 1
        end  
        if @direction == "left"
            @head.x = @head.x - 1
        end
        if @direction == "up"
            @head.y = @head.y - 1
        end
        if @direction == "down"
            @head.y = @head.y + 1
        end
    end
end

class Head < Struct.new(:x, :y)
    def char
        "o"
    end

    def color
        Curses::COLOR_GREEN
    end
end 


class Tail
    def initialize(initial_segments)
        @segments = initial_segments
    end

    def segments
        @segments
    end
end

class TailSegment < Struct.new(:x, :y)
    def char
        "o"
    end
end  

class Apple < Struct.new(:x, :y)
    def char
        "*"
    end

    def color
        Curses::COLOR_RED
    end
end 

class SnakeGame    
    def initialize(width, height)
        @snake = Snake.new
        @width = width
        @height = height 
        @apple = Apple.new(rand(@width), rand(@height))
        @score = 0
    end
    
    def objects
        [
            @snake.head,
            @apple,
        ] + @snake.tail.segments
    end

    def input_map
        {
            "a" => :turn_left,
            "d" => :turn_right,
            "w" => :turn_up,
            "s" => :turn_down,
            "q" => :exit,
        }
    end

    def turn_left
        @snake.change_direction("left")
    end

    def turn_right
        @snake.change_direction("right")
    end

    def turn_up
        @snake.change_direction("up")
    end

    def turn_down
        @snake.change_direction("down")
    end

    def tick
        move_snake
        handle_wall_hit
        apple_eat?
    end

    def handle_wall_hit
        if wall_hit?
            exit
        end
    end

    def wall_hit?
        if @snake.head.x == 0 or @snake.head.x == @width
            exit
        end
        if @snake.head.y == 0 or @snake.head.y == @height
            exit
        end
    end

    def apple_eat?
        if @snake.head.x == @apple.x and @snake.head.y == @apple.y

            @apple = Apple.new(rand(@width), rand(@height))
            
            @score = @score + 1
        end
    end


    def move_snake
        @snake.move()
    end

    def wait?
        false
    end
    
    def sleep_time
        0.2
    end


    def textbox_content
        "apples eaten: %d" % @score 
    end

    def exit
        Kernel.exit
    end

    def exit_message
        "bye"
    end 
end 

Gaminator::Runner.new(SnakeGame, :rows => 30, :cols => 80).run

