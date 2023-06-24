require "curses"
require "gaminator"

class Snake
end


Gaminator::Runner.new(Snake, :rows => 30, :cols => 80).run
