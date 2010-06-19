# Square

class Square < Processing::App
  def setup
    no_stroke
    frame_rate 25
  end

  def draw
    fill 255, 20
    rect 0, 0, width , height # background 255
    no_fill
    30.to_i.times do
      #rect random(width), random(height), random(mouse_x), random(mouse_y)
      w = random(mouse_x)
      h = w # random(mouse_y)
      stroke random(255), random(255), random(255)
      rect(width/2 - w/2, height/2 - h/2, w, h)
    end
  end

  def key_pressed
    background 0
  end
end

Square.new :title => "Square", :width => 620, :height => 620
