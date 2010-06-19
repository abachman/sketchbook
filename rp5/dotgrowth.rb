# Dotgrowth


class Dotgrowth < Processing::App
  class Dot
    attr_accessor :x, :y, :dx, :dy, :remove
    def initialize opts={}
      o = {
        :x => 0,
        :y => 0,
        :dx => 1,
        :dy => 1
      }.merge(opts)
      @x = o[:x]
      @y = o[:y]
      @dx = o[:dx]
      @dy = o[:dy]
      @remove = false
    end

    def update
      @x += dx
      @y += dy

      if x > width || x < 0 || y > height || y < 0
        @remove = true
      end
    end

    def draw
      rect x, y, 10, 10
    end
  end

  def setup
    background 0
    frame_rate 30
    @cs = []
    20.times do
      @cs << Dot.new(:x => random(width),
                     :y => random(height),
                     :width => width,
                     :height => height)
    end
  end

  def draw
    fill 0, 15
    rect 0, 0, width, height
    fill 255
    @cs.each {|c| c.update; c.draw }
    @cs = @cs.select {|c| !c.remove }
    # ellipse random(width), random(height), 10, 10
  end
end

Dotgrowth.new :title => "Dotgrowth", :width => 600, :height => 800
