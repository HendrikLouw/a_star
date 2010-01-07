# This example demonstrates the use of a_star.rb on a map with hexagonal cells,
# like a honeycomb. The only difference between this and the grid example is
# that each cell has six neighbors instead of four. A five-cell wall is placed
# in the middle of the map.
#
# . . . . . . . . .
#  . . . . . . . .
# . . . . . . . . .
#  . . . . . . . .
# . . X X X X X . .
#  . . . . . . . .
# . . . . . . . . .
#  . . . . . . . .
# . . . . . . . . .

require File.dirname(__FILE__) + "/../a_star"

class Honeycomb
  attr_reader :height
  
  # +width+ is the width of the wider rows. The first row has +width+ cells,
  # the second has +width - 1+ cells, the third has +width+ cells, and so on.
  def initialize(width, height)
    @width = width
    @height = height
    @impassable_cells = Set.new
  end
  
  def width(y = 0)
    @width - (y & 1)
  end
  
  def wide_row?(y)
    y & 1 == 0
  end
  
  def make_impassable(x, y)
    @impassable_cells.add(Cell.new(x, y, self))
  end
  
  def passable?(cell)
    !@impassable_cells.include?(cell)
  end
  
  def cell_at(x, y)
    return nil if x < 0 || y < 0 || x >= width(y) || y >= height
    Cell.new(x, y, self)
  end
  
  class Cell < AStarNode
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
      if @grid.wide_row?(y)
        result = [
          @grid.cell_at(x - 1, y - 1),
          @grid.cell_at(x    , y - 1),
          @grid.cell_at(x - 1, y    ),
          @grid.cell_at(x + 1, y    ),
          @grid.cell_at(x - 1, y + 1),
          @grid.cell_at(x    , y + 1),
        ]
      else
        result = [
          @grid.cell_at(x    , y - 1),
          @grid.cell_at(x + 1, y - 1),
          @grid.cell_at(x - 1, y    ),
          @grid.cell_at(x + 1, y    ),
          @grid.cell_at(x    , y + 1),
          @grid.cell_at(x + 1, y + 1),
        ]
      end
      result.delete_if {|cell| cell.nil? || !cell.passable?}
      result
    end
    
    def guess_distance(cell)
      (x - cell.x).abs + (y - cell.y).abs
    end
    
    def hash
      (x << 16) | y
    end
    
    def eql?(obj)
      obj.is_a?(Cell) && obj.x == x && obj.y == y && obj.grid == grid
    end
    alias_method :==, :eql?
    
    def inspect
      "(#{x},#{y})"
    end
  end
end

# Make the honeycomb and put a wall in the middle.
h = Honeycomb.new(9, 9)
h.make_impassable(2, 4)
h.make_impassable(3, 4)
h.make_impassable(4, 4)
h.make_impassable(5, 4)
h.make_impassable(6, 4)

# Find the shortest path between two points on either side of the wall.
p1 = h.cell_at(4, 0)
p2 = h.cell_at(4, 8)
cost, path = p1.path_to(p2)

# Print a little map of the honeycomb, its wall, and the path we found.
h.height.times do |y|
  print " " unless h.wide_row?(y)
  h.width(y).times do |x|
    cell = h.cell_at(x, y)
    if !cell.passable?
      print "X "
    elsif path.include?(cell)
      print "# "
    else
      print ". "
    end
  end
  print "\n"
end
