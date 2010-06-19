# Cpad

class Cpad < Processing::App
  load_java_library :procontroll
  include_package "procontroll"
  # include_package 'net.java.games.input'

  def setup
    background 200, 200, 0
    ControllIO.print_devices
  end

  def draw
    fill 0
    ellipse 30, 30, 30, 30
  end
end

Cpad.new :title => "Cpad", :width => 400, :height => 400
