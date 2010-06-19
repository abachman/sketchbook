# Curvex

class Curvex < Processing::App
  def setup
    background 0
    no_fill
    stroke 255
    frame_rate 25
  end

  def draw
    background 0
    begin_shape

    (1..height).step(10).each do |y|
      shiftness = (mouse_y / y)
      shiftness = shiftness == 0 ? 0 : 1 / shiftness
      curve_vertex mouse_x * shiftness, y
    end

    end_shape
  end
end

Curvex.new :title => "Curvex",
  :width => 640,
  :height => 800
