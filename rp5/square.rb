# Square

class Square < Processing::App
  def setup
    _w = (ENV['width'] || 640).to_i
    _h = (ENV['height'] || 480).to_i
    size _w, _h
    # stroke_width 2
    no_fill
    frame_rate 10
  end

  def draw
    background 255

    120.to_i.times do
      #rect random(width), random(height), random(mouse_x), random(mouse_y)
      w = random(height / 2)
      h = w # random(mouse_y)
      stroke random(255), random(255), random(255)
      rect(width/2 - w/2, height/2 - h/2, w, h)
    end

    save "square-#{width}x#{height}.png"
    exit
  end

  def key_pressed
    background 0
  end
end

Square.new :title => "Square", :width => 620, :height => 620
