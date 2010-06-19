HEIGHT = 1600
WIDTH  = 1800
SCALING = 20.0

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

def place_pattern l, x_off, y_off
  # x_off, y_off = random(width), random(height)
  l.map {|(x, y)| [x + x_off, y + y_off ]}
end

def scale p
  [ p[0] * @scaling, p[1] * @scaling ]
end

def setup
  size(WIDTH, HEIGHT)
  noStroke
  smooth
  fill 255
  frameRate 60
  background 0
  #@world = to_center(patterns[:acorn])
  @world = []
  @step = 0
  @scaling = SCALING
  @alpha = 3
end

def draw
  #@scaling = map(mouse_x, 0, width, 0, 20)
  #@alpha = map(mouse_y, 0, height, 0, 100)

  # puts @world.inspect
  # background 0
  fill 0, @alpha
  rect 0, 0, width, height
  fill 255, 40

  @world = @world.select {|p|
    x, y = scale p
    x < width && x > 0 && y < height && y > 0
  }

  # draw points
  @world.each {|p|
    x, y = scale p
    if x < width && x > 0 && y < height && y > 0
      ellipse(x, y, @scaling * 2, @scaling * 2)
    end
  }
  @step += 1
  @world = step(@world)

  # delete a random spot every 2 steps
  if @step % 20 == 0
    @world.pop(random(@world.length))
  end

  if @step % 3 == 0
    launch random(width), random(height)
  end

  if @step % 100 == 0
    puts 'closer...'
  end

  if @step > 300
    save_frame("background.png")
    exit
  end
end

def rotate_pattern p
  i = random(0, 4).to_i
  case i
  when 0
    p.map {|(x, y)| [-x, y]}
  when 1
    p.map {|(x, y)| [x, -y]}
  when 2
    p.map {|(x, y)| [-x, -y]}
  when 3
    p
  end
end

def launch x, y
  p = rotate_pattern(patterns[:glider])
  x_off = map(x, 0, width, 0, width / @scaling)
  y_off = map(y, 0, height, 0, height / @scaling)
  place_pattern(p, x_off, y_off).inject(@world, &:<<)
end

def mouse_pressed
  launch mouse_x, mouse_y
end

def reset_world
  @world = []
end

def key_pressed
  if key == ' '
    reset_world
  end
end
