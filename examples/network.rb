# This example demonstrates how to use a_star.rb with a network of connected
# points, like a street map or train route map. It also makes use of movement
# costs: weights are assigned to the network's connections. In the street map
# analogy, one might think of the weights as being inversely related to speed
# limits.
#
# The network created by the example looks like this:
#
#  A----B
#  |   / \
#  |  F   C
#  |     /
#  E----D
#
# The example finds paths from A to F and from A to C. The path from A to C
# will go through E and D, not B, because a high cost is assigned to the
# connection between B and C.

require File.dirname(__FILE__) + "/../a_star"

class Node < AStarNode
  attr_reader :name
  alias_method :inspect, :name
  
  def initialize(name)
    @name = name
    @connections = {}
  end
  
  def connect(other, weight, back = true)
    @connections[other] = weight
    other.connect(self, weight, false) if back
  end
  
  def guess_distance(other)
    @connections[other] || @connections.values.min
  end
  
  def neighbors
    @connections.keys
  end
  
  def movement_cost(other)
    @connections[other]
  end
end

# Create the network.
A = Node.new("A")
B = Node.new("B")
C = Node.new("C")
D = Node.new("D")
E = Node.new("E")
F = Node.new("F")

A.connect(B, 1)
A.connect(E, 1)
B.connect(F, 1)
B.connect(C, 10)
C.connect(D, 1)
D.connect(E, 1)

# Find paths and print them.
puts " A----B"
puts " |   / \\"
puts " |  F   C"
puts " |     /"
puts " E----D"
print "\n"

cost, path = A.path_to(F)
path.collect! {|node| node.name}
puts "A -> F"
puts "Total Cost: #{cost}"
puts "Path: #{path.join(', ')}"
print "\n"

cost, path = A.path_to(C)
path.collect! {|node| node.name}
puts "A -> C"
puts "Total Cost: #{cost}"
puts "Path: #{path.join(', ')}"
