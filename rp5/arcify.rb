# Arcify

full_screen
class Arc
  attr_accessor :id
  def initialize x,y,r,s,f,i
    @x = x
    @y = y
    @r = r
    @s = s
    @f = f
    @id = i
    @v = random(0.01, 0.3)
    @color = color(map(@r, 0, width, 0, 100),
                   100, random(20, 80))
  end

  def update cond
    if cond
      @s += @v
      @f += @v
#      @s += (@r/10 * 0.01)
#      @f += (@r/10 * 0.01)
    end
  end

  def drawme
    stroke @color
    arc @x, @y, @r, @r, @s, @f
  end
end

def setup
  no_fill
  size 800, 640
  color_mode HSB, 100
  ellipse_mode CENTER
  stroke_width 20
  stroke_cap SQUARE
  stroke 255

  @s = 0
  @f = PI / 2
  keys = %w(q w e r t y u i o p a s d f g h j k l z x c v b n m)
  @pressed = keys.inject({}) {|a, k|
    a[k]=false; a }

  @as = (100..1100).step(30).map do |r|
    Arc.new 0, 0, r, @s, @f, keys.shift
  end

  no_cursor

end

def draw
  fill 0, 30
  no_stroke
  rect 0, 0, width, height
  no_fill

  push_matrix
  translate width/2, height/2

  @as.each do |a|
    a.update !@pressed[a.id]
    a.drawme
  end

  pop_matrix
end

#def key_pressed; @pressed[key] = true; end
#def key_released; @pressed[key] = false; end
def key_pressed
  if key == ' '
    no_stroke
    fill 0, 100, 100
    rect 0, 0, width, height
  end

  @pressed[key] = !@pressed[key]
end
#def key_released; @pressed[key] = false; end
