# This is an example of how to use a_star.rb to find paths on a grid with a
# number of impassable grid squares. The example implements two classes: Grid
# represents the grid itself; Grid::Square represents a particular square on
# the grid and is the AStarNode subclass. Movement from one square to another
# is permitted up, down, left, and right--not diagonally.
#
# The example first creates a 9x9 grid with two three-square "walls" in the
# middle, like so:
#
# .........
# .........
# ......X..
# ......X..
# ..X...X..
# ..X......
# ..X......
# .........
# .........
#
# It then finds the shortest path from two squares on either side of the walls
# and prints a map of the result.

require File.dirname(__FILE__) + "/../a_star"

class Grid
  attr_reader :width, :height
  
  def initialize(width, height)
    @width = width
    @height = height
    @impassable_squares = Set.new
  end
  
  def make_impassable(x, y)
    @impassable_squares.add(Square.new(x, y, self))
  end
  
  def passable?(square)
    !@impassable_squares.include?(square)
  end
  
  def square_at(x, y)
    return nil if x < 0 || y < 0 || x >= width || y >= height
    Square.new(x, y, self)
  end
  
  class Square < AStarNode
    attr_reader :x, :y, :grid
    
    def initialize(x, y, grid)
      @x = x
      @y = y
      @grid = grid
    end
    
    def passable?
      @grid.passable?(self)
    end
    
    def neighbors
      result = [
        @grid.square_at(x,     y - 1),
        @grid.square_at(x - 1, y    ),
        @grid.square_at(x + 1, y    ),
        @grid.square_at(x,     y + 1),
      ]
      result.delete_if {|square| square.nil? || !square.passable?}
      result
    end
    
    def guess_distance(square)
      (x - square.x).abs + (y - square.y).abs
    end
    
    def hash
      (x << 16) | y
    end
    
    def eql?(obj)
      obj.is_a?(Square) && obj.x == x && obj.y == y && obj.grid == grid
    end
    alias_method :==, :eql?
    
    def inspect
      "(#{x},#{y})"
    end
  end
end

# Make the grid and put two walls in the middle.
g = Grid.new(9, 9)
g.make_impassable(6, 2)
g.make_impassable(6, 3)
g.make_impassable(6, 4)
g.make_impassable(2, 4)
g.make_impassable(2, 5)
g.make_impassable(2, 6)

# Find the shortest path between two points on either side of the walls.
p1 = g.square_at(0, 4)
p2 = g.square_at(8, 4)
cost, path = p1.path_to(p2)

# Print a little map of the grid, its wall, and the path we found.
g.height.times do |y|
  g.width.times do |x|
    square = g.square_at(x, y)
    if !square.passable?
      print "X"
    elsif path.include?(square)
      print "#"
    else
      print "."
    end
  end
  print "\n"
end
