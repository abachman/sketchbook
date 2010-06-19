# Arcify

class Arcify < Processing::App
  class Arc
    attr_accessor :id
    def initialize x,y,r,s,f,i
      @x = x
      @y = y
      @r = r
      @s = s
      @f = f
      @id = i
      @color = color(map(@r, 0, width, 0, 100), 50, 255)
    end

    def update cond
      if cond
        @s += (@r * 0.1)
        @f += (@r * 0.1)
      end
    end

    def drawme
      stroke @color
      arc @x, @y, @r, @r, @s, @f
    end
  end

  def setup
    no_fill
    color_mode HSB, 100
    ellipse_mode CENTER
    stroke_width 20
    stroke_cap SQUARE
    stroke 255

    @s = 0
    @f = PI / 2
    keys = %w(q w e r t y u i o p a s d f g h)
    @pressed = keys.inject({}) {|a, k| 
      a[k]=false; a }

    @as = (100..900).step(80).map do |r|
      Arc.new 0, 0, r, @s, @f, keys.shift
    end
  end

  def draw
    fill 0, 30
    no_stroke
    rect 0, 0, width, height
    no_fill

    push_matrix
    translate width/2, height/2

    @as.each do |a|
      a.update @pressed[a.id]
      a.drawme
    end

    pop_matrix
  end

  def key_pressed
    @pressed[key] = !@pressed[key]
  end
  # def key_released
  #   @pressed[key] = false
  # end
end

Arcify.new :title => "Arcify",
  :width => 1100,
  :height => 780
