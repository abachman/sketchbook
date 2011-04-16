# Circle Grid
require 'ostruct'

attr_accessor :c, :step

def setup
  size 580,600
  background 255
  ellipse_mode CENTER
  stroke_width 20
  frame_rate 30
  no_cursor

  @step = 64
  @c = []
  @min = 20
  @max = 200
  (0..width).step(@step).each do |x|
    (0..height).step(@step).each do |y|
      c = OpenStruct.new
      c.x = x
      c.y = y
      c.dr = random(1,50)
      c.r = random(@min, @max)
      c.c = color(0, # random(0, 100),
                  random(100, 200),
                  0) # random(100))
      @c << c
    end
  end
  @keys = {}
end

def draw
  no_stroke
  fill 255, 20
  rect 0, 0, width, height
  no_fill
  stroke 0

  @c.each do |c|
    # update
    c.r += c.dr
    if c.r < @min || c.r > @max
      c.dr *= -1
    end
    # draw
    dx = (mouse_x - c.x).abs
    dy = (mouse_y - c.y).abs
    # auto
    if @keys[' ']
      stroke c.c # , map(c.r, @min - 51, @max, 0, 100)
      ellipse c.x, c.y, c.r, c.r
    else
      # mouse
      stroke 200 - c.r, 255- c.r, c.r
      ellipse c.x, c.y, dx, dy
    end
  end
end

def key_pressed
  @keys[key] = true
end
def key_released
  @keys[key] = false
end

def mouse_pressed
  save_frame "20100618/#{ Time.now.to_i }.png"
end
