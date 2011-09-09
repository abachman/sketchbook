def setup
  size 500, 500
  background 0
  frame_rate 30
  no_stroke
end

def draw
  background 0
  fill 255
  push_matrix
  rotate .1
  1000.times {
    rect random(width), random(height), 2, 2
  }
  pop_matrix
end
