require_relative 'graph'
require 'byebug'

# O(|V|**2 + |E|).
def dijkstra1(source)
  locked_in_paths = {}
  possible_paths = {
    source => { cost: 0, last_edge: nil }
  }

  # Runs |V| times max, since a new node is "locked in" each round.
  until possible_paths.empty?
    # take the minimum cost vertex
    vertex = select_possible_path(possible_paths)

    # add the minimum cost vertex to locked in paths
    locked_in_paths[vertex] = possible_paths[vertex]

    # the current vertex's possible path from the source
    # is locked in when it is reached.
    # so there is nothing further to explore for that vertex
    possible_paths.delete(vertex)


    update_possible_paths(vertex, locked_in_paths, possible_paths)
  end

  locked_in_paths
end

# O(|V|) time, as `possible_paths` has as many as |V| entries.
def select_possible_path(possible_paths)
  # find min cost vertex
  # this iteration is the bottleneck :(
  vertex, data = possible_paths.min_by do |(vertex, data)|
    data[:cost]
  end

  vertex
end

def update_possible_paths(vertex, locked_in_paths, possible_paths)
  # get cost of current vertex's path
  path_to_vertex_cost = locked_in_paths[vertex][:cost]

  # We'll run this |E| times overall.
  # look at all the outgoing edges from the vertex
  vertex.out_edges.each do |e|
    to_vertex = e.to_vertex

    # Already locked in a best path for this vertex
    # A shortest path has already been found for this to_vertex
    next if locked_in_paths.has_key?(to_vertex)

    # add the cost of the edge (to the to_vertex) to the path.
    extended_path_cost = path_to_vertex_cost + e.cost
    # skip if there is a shorter path already found
    next if possible_paths.has_key?(to_vertex) &&
            possible_paths[to_vertex][:cost] <= extended_path_cost

    # We found a better path to `to_vertex`!
    possible_paths[to_vertex] = {
      cost: extended_path_cost,
      last_edge: e
    }
  end
end
