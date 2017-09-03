require_relative 'heap2'

class PriorityMap
  def initialize(&prc)
    self.map = {}
    # proc that sorts elements based on their values in the map,
    # which is the data ({cost: something, last_edge: something})
    self.queue = BinaryMinHeap.new do |key1, key2|
      # the proc passed in at dijkstra 2 sorts by cost
      prc.call(self.map[key1], self.map[key2])
    end
  end

  def [](key)
    return nil unless self.map.has_key?(key)
    self.map[key]
  end

  def []=(key, value)
    if self.map.has_key?(key)
      update(key, value)
    else
      insert(key, value)
    end
  end

  def count
    self.map.count
  end

  def empty?
    count == 0
  end

  def extract
    # uses MinHeap's extract: worst case O(log(n))
    key = self.queue.extract
    value = self.map.delete(key)

    [key, value]
  end

  def has_key?(key)
    self.map.has_key?(key)
  end

  # protected
  attr_accessor :map, :queue

  def insert(key, value)
    # uses MinHeap's push: worst case O(log(n))
    self.map[key] = value
    self.queue.push(key)

    nil
  end

  def update(key, value)
    throw "tried to update non-existent key" unless self.map.has_key?(key)
    self.map[key] = value
    # leads to heapify_up at that value's index
    self.queue.reduce!(key)

    nil
  end
end

# TESTING

def main
  pm = PriorityMap.new { |value1, value2| value1 <=> value2 }
  pm["A"] = 10
  pm["B"] = 15
  pm["B"] = 5

  p pm
end

main if __FILE__ == $PROGRAM_NAME
