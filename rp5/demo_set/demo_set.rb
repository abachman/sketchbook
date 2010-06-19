# Demo Set
#

class DemoSet < Processing::App
  class Circle
    def initialize x, y, dx, dy
      @x = x
      @y = y
      @dx = dx
      @dy = dy
    end

    def update
      @x += @dx
      if @x > width || @x < 0
        @dx = -@dx
      end

      @y += @dy
      if @y > height || @y < 0
        @dy = -@dy
      end
    end

    def draw
      stroke 7, 146, 208
      stroke_width 4
      fill 255
      ellipse @x, @y, 20, 20
    end
  end

  # load_libraries :
  # We need the OpenGL classes to be included here.
  # include_package "processing.opengl"
  def setup
    background 0
    font = load_font "data/DroidSansMono-24.vlw"
    text_font(font)

    @c = []
    generate
  end

  def draw
    noStroke
    fill(0, 10)
    rect(0, 0, width, height)

    stroke 7, 146, 208
    stroke_width 4
    fill 255

    @c.each {|c| c.update}
    @c.each {|c| c.draw}
    fill 255, 0, 0
    text(@c.count, 15, 30)
  end

  def generate
    @c << Circle.new(random(width), random(height), random(10), random(10))
  end

  def mouse_pressed
    random(5).to_i.times { generate }
  end
end

DemoSet.new :title => "Demo Set", :width => 620, :height => 700
