def setup
  size 1024/2, 768 - 14
  background 0
  no_stroke
  smooth
end

def draw
  fill 0, 30
  rect 0, 0, width, height
  fill 255
  10.times do
    ellipse random(width), random(height), 10, 10
  end
end
