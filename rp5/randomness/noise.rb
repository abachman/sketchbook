
def setup
  size 640, 480
  background 51
  noStroke
  smooth
  frameRate 24

  load_pixels

  @length = pixels.length
  @white = color 255
end

def draw
  background 51
  load_pixels
  1000.times do
    p = random(@length).to_i
    pixels[p] = @white
  end
  update_pixels
end
