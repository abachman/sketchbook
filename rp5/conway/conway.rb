HEIGHT = 400
WIDTH  = 400

DXY = [[-1,-1],[0,-1],[1,-1],[-1,0],[1,0],[-1,1],[0,1],[1,1]]
# a 400 by 400 2D array
# FIELD = (0..400).inject([]) {|y, n| y << ((0..400).map {|n| 0}); y }

def neighborhood x, y
  DXY.map {|(dx, dy)|
    [x + dx, y + dy]
  }
end

def step world
  _interesting_neighbors = []
  # live neighbors
  _next_world = world.inject([]) {|next_world, (x, y)|
    dead_neighbors = neighborhood(x, y) - world
    if dead_neighbors.length == 5 || dead_neighbors.length == 6
      # live on
      next_world << [x, y]
    end
    _interesting_neighbors += dead_neighbors
    next_world
  }

  _interesting_neighbors.uniq.inject(_next_world) {|next_world, (x, y)|
    dn = neighborhood(x, y) - world
    if dn.length == 5
      next_world << [x, y]
    end
    next_world
  }
end

def to_pairs s
  out = []
  s.map(&:to_i).each_slice(2) {|s|
    out << s
  }
  out
end

def patterns
  {
    :r_pentomino => to_pairs(%w{
      0 -1
     -1 -1
     -1 0
      0 0
      0 1
    }),
    :oscillator => to_pairs(%w{
     -1 0
      0 0
      1 0
    }),
    :glider => to_pairs(%w{
      3 0
      3 1
      1 1
      2 2
      3 2
    }),
    :acorn => to_pairs(%w{
      1 0
      3 1
      0 2
      1 2
      4 2
      5 2
      6 2
    })
  }
end

# move a collection of points centered on 0,0 to the middle of the sketch
def to_center l
  l.map {|(x, y)| [x + width / 2, y + height / 2]}
end

def setup
  size(WIDTH, HEIGHT)
  background 0
  noStroke
  fill 255
  frameRate 20

  @world = to_center(patterns[:acorn])
end

def draw
  # puts @world.inspect
  background 0
  @world.each {|(x, y)|
    set(x, y, color(255)) if x < width && x > 0 && y < height && y > 0
  }
  @world = step(@world)
end
