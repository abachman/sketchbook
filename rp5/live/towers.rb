full_screen

def setup
  size 1000, 600
  @bg = 0
  background @bg
  fill 30
  no_stroke
  no_cursor

  @step = 20
  @x = 0
  @y = 0
end

def draw
  fill @bg, 30
  rect 0, 0, width, height

  #horiz
  fill 0, map(mouse_x, 0, width, 100, 255), 0, 60
  rect @x, map(mouse_y, 0, height, height/2, 0),
    20, mouse_y
  @x = (@x + @step) % width

  # vert
  fill map(mouse_y, 0, width, 100, 255), 0, 0, 60
  rect map(mouse_x, 0, width, width/2, 0), @y,
    mouse_x, 20
  @y = (@y - @step) % width

  # fill 0, 0, 200, 30
  # ellipse mouse_x, mouse_y, 40, 40
end

def key_pressed
  @bg = 255
end

def key_released
  @bg = 0
end

