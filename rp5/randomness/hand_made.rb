def get_random
  @m_z = 36969 * (@m_z & 65535) + (@m_z >> 16)

  @m_w = 18000 * (@m_w & 65535)
  @m_w = (@m_w >> 16)

  (@m_z << 16) + @m_w
end

def setup
  size 640, 480
  background 51
  noStroke
  smooth
  frameRate 10

  load_pixels

  @length = pixels.length
  @white = color 255

  @m_w = 3
  @m_z = 2

  puts 'set'
end

def draw
  puts ((1.0 / get_random) * @length).to_i
  puts " #{ random(@length).to_i }"

  background 51
  load_pixels
  1000.times do
    p = random(@length).to_i
    pixels[p] = @white
  end
  update_pixels
end
