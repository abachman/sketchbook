# Lines
class Lines < Processing::App
  class Dot
    def initialize
      @x = random(width)
      @y = random(height)
      @dx = random(20)
      @dy = random(20)
      @g = random(30, 200)
      @lean = random(40)
    end

    def update
      @x += @dx
      @y += @dy

      if @x < 0 || @x > width 
        @dx = -@dx
      end

      if @y < 0 || @y > height
        @dy = -@dy
      end
    end

    def draw
      stroke 0, @g, 0
      bezier width/2, height, @x/2, @lean, @lean, @y/2, @x, @y
    end
  end

  def setup
    background 0
    #smooth
    @ds = [ Dot.new ]
  end

  def draw
    fill 0, 10
    rect 0, 0, width, height

    no_fill
    @ds.map &:update
    @ds.map &:draw
  end

  def mouse_pressed
    fill 255
    rect 0, 0, width, height
    @ds << Dot.new
  end
end

Lines.new :title => "Lines", :width => 630, :height => 800
