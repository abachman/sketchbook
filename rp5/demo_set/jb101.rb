def setup
  size 400, 400
  background 0
  @counter = 0
  frame_rate 30
end

def draw 
  background 0
  fill 255
  rect width/2, @counter % 400, 10, 10

  @counter += 10
end
