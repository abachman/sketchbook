def setup 
  size 600, 700
  background 0
  no_stroke
  @t = 0
end

def draw
  fill 0, 10
  rect 0, 0, width, height

  push_matrix
  translate 0, @t
  fill 255
  50.times do
  ellipse random(width), random(height), 10, 10
  end
  pop_matrix

  @t = height % (@t + 1)
end
