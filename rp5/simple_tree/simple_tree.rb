# fun things to do with live
# > def t; Thread.new { yield }.run; end
# > def r(a); a.each {|i| yield i }; end
# > t { r((1..30)) {|i| r((1..100)) {|n| $app.diverge = 3.0 / n; sleep 0.02}; sleep 2} }

class MySketch < Processing::App
  attr_accessor :diverge, :looping, :mouse_divergence, :max_limb, :max_depth

  def setup
    @max_limb = 75 # branch length
    @max_depth = 5 # branches
    @mouse_divergence = true
    @diverge = 0.3 # branch split
    @looping = true

    size 800, 820, P2D
    background 0
    noStroke
    # smooth
  end

  def draw
    # background 0
    fill 0, 10
    rect 0, 0, width, height

    translate(width / 2, height / 2)
    tree(0, 0, 0, 0, max_limb)

    # down
    pushMatrix
    rotate(HALF_PI)
    tree(0, 0, 0, 0, max_limb)

    # left
    pushMatrix
    rotate(HALF_PI)
    tree(0, 0, 0, 0, max_limb)

    # up
    pushMatrix
    rotate(HALF_PI)
    tree(0, 0, 0, 0, max_limb)

    # return to default
    popMatrix
    popMatrix
    popMatrix

    #/ Cycle divergence value
    @diverge += 0.02 if (!mouse_divergence)
  end

  def mousePressed
    if (looping)
      noLoop
      @looping = false
    else
      loop
      @looping = true
    end
  end

  def mouseMoved()
    ##/ Set divergence value according to mouseY
    if (mouse_divergence)
      @diverge = map(mouseY, 0, height, 0, TWO_PI)
    end
  end

  def tree startx, starty, level, direction, length
    ## Set branch divergence randomly.
    # diverge = random(0, 1.0)

    #### Set branch length randomly.
    ## length = random(5, length * 2)

    if (length > 0 && level < max_depth)
      #/**
      # * Polar to Rectangular coordinate conversions.
      # * x = r cos(q), y = r sin(q), where r is radius and q is angle in radians.
      # */
      endx = startx + (length * cos(direction))
      endy = starty + (length * sin(direction))

      ## String fmt = "tree: level %fstartx %fstarty %fendx %fendy %fr %fq %f"
      ## println(String.format(fmt, level, startx, starty, endx, endy, r, direction))

      ## Draw tree
      stroke(255)
      strokeWeight(max_depth - level)
      line(startx, starty, endx, endy)

      ## Left tree
      tree(endx, endy, level + 1, direction - diverge, length)
      ## Right tree
      tree(endx, endy, level + 1, direction + diverge, length)
    else
      ## Draw a leaf at the end of each branch.
      noStroke()
      fill(0, 255, 0)
      ellipse(startx, starty, 10, 10)
    end
  end
end
