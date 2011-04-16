# Treelike
class Leaf
  def initialize *args
    @x, @y, @d, @r, @p = *args
    @spread = random(10, 40)
    @children = []
    @curve = random(-0.5, 0.5)
  end

  def drawme
    fill color(0,
               map(@d, 0, 40, 0, 255),
               0)
    rect @x, @y, @d, @d
    if @children.length > 0
      @children.map{|t| t.drawme}
    end
  end

  def grow
    # puts "#{@x},#{@y} is growing"
    return false if @dead

    if @children.length > 0
      return @children.map{|t| t.grow}.any?
    end

    # shrink?
    if random(0, 100) < 40
      nd = @d - 0.2
      if nd < 0
        @dead = true
        return false
      end
    end

    # branch?
    if random(0, 100) < 20
      @children << Leaf.new(@x - @spread,
                            @y - @d,
                            @d - 2)
      @children << Leaf.new(@x + @spread,
                            @y - @d,
                            @d + 2)
      return true
    end

    # die?
    if random(0, 100) < 10
      @dead = true
      return false
    end

    # otherwise...
    nx = @x + @curve
    ny = @y - @d

    if nx > width || nx < 0
      @dead = true
      return false
    end

    if ny > height || ny < 0
      @dead = true
      return false
    end

    @children << Leaf.new(@x + @curve, @y - @d, @d)
    return true
  end
end

def setup
  @s = 10
  build_tree
  frame_rate 30
  stroke 50
  size 560, 600
end

def draw
  background 0
  if !@root.grow
    build_tree
  else
    @root.drawme
  end
end

def mouse_pressed
  save_frame 'treelike.png'
end

def build_tree
  @root = Leaf.new(width/2, height, 20)
end
