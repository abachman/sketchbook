def setup
  size 640, 480
  noStroke

  @img         = load_image 'gradient.png'
  @skull       = load_image 'skull.png'
  @cell_size   = 8
  @noise_scale = 0.03
  @z_value     = 0
  @xy_offset   = 0
end

def draw
  background 51
  make_fire
end

def make_fire
  (width / @cell_size).times do |x|
    (height / @cell_size).times do |y|
      nx = (x) * @noise_scale
      # fire moves upwards
      ny = (@xy_offset + y) * @noise_scale
      nz = @z_value * @noise_scale

      # draw red rectangle
      fill 255 * noise(nx, ny, nz), 0, 0
      rect x * @cell_size, y * @cell_size, @cell_size, @cell_size
    end
  end

  # black-to-transparent overlay
  imageMode(CORNERS)
  (width / 16).times do |n|
    image(@img, n * 16, 0)
  end

  imageMode(CENTER)
  image @skull, width / 2, height / 2 + height / 4

  @xy_offset += 2
  @z_value += 1
end
