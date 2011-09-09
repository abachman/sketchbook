# From the Processing Examples
# Uses the "bare" style, where a Processing::App sketch is implicitly wrapped
# around the code.
# -- omygawshkenas

FRAME_COUNT = 24

def setup
  @frames         = []
  @last_time      = 0
  @current_frame  = 0
  @draw           = false
  @back_color     = 0
  @color = 255
  @i = 0
  size 500, 350
  no_stroke
  fill 0

  smooth
  background @back_color
  FRAME_COUNT.times { @frames << get() }
end

def draw
  time = millis()
  if time > @last_time + 100
    next_frame
    @last_time = time
  end

  # line(pmouse_x, pmouse_y, mouse_x, mouse_y) if @draw
  if @draw
    fill @back_color, 40
    rect 0, 0, width, height
    fill @color
    _d = dist(pmouse_x, pmouse_y, mouse_x, mouse_y)
    ellipse(mouse_x,
            mouse_y,
            _d, _d)
  end
end

def abs n
  if n < 0
    n *= -1
  else
    n
  end
end

def mouse_pressed; @draw = true; end
def mouse_released;
  @draw = false;
  color_step
end

def color_step
  @i = (@i + 1) % 24
  @r = 128+sin((@i*3+0)*1.3)*128
  @g = 128+sin((@i*3+1)*1.3)*128
  @b = 128+sin((@i*3+2)*1.3)*128
  @color = color @r, @g, @b # (@color + 10) % 255
end

def key_pressed
  background @back_color
  @frames.size.times {|i| @frames[i] = get()}
end

def next_frame
  @frames[@current_frame] = get()
  @current_frame += 1
  @current_frame = 0 if @current_frame >= @frames.size
  image(@frames[@current_frame], 0, 0)
end
