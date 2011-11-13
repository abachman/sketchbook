def mode
  :fire
end

def setup
  size 640, 480
  background 51
  @cell_size = 8
  frameRate 20

  if mode == :fire
    @xy_offset = 0
  elsif mode == :smoke
    # pass
    frameRate 1
  else
    color_mode HSB
  end

  noise_seed random(100)
  noStroke

  @img = load_image 'gradient.png'

  @noise_scale = 0.02

  @z_value = 0
end

# def draw
#   load_pixels
#   p_count = 0
#   (height).times do |y|
#     (width).times do |x|
#       nx = x * @noise_scale
#       ny = y * @noise_scale
#       nz = @z_value * @noise_scale
#       pixels[p_count] = color 255 * noise(nx, ny, nz), 255, 255
#       p_count += 1
#     end
#   end
#   update_pixels
#
#   @z_value += 1
# end

def draw
  background 51
  if mode == :fire
    make_fire
  elsif mode == :smoke
    load_pixels
    p_count = 0
    height.times do |y|
      width.times do |x|
        nx = (mouseX + x) * @noise_scale
        ny = (mouseY + y) * @noise_scale
        # nz = @z_value * @noise_scale
        pixels[p_count] = color 255 * noise(nx, ny)
        p_count += 1
      end
    end
    @z_value += 1
    update_pixels
    # no_loop
  else
    heat_mapper
  end
end

def heat_mapper
  (width / @cell_size).times do |x|
    (height / @cell_size).times do |y|
      nx = x * @noise_scale
      ny = y * @noise_scale
      nz = @z_value * @noise_scale
      fill 255 * noise(nx, ny, nz), 255, 255
      rect x * @cell_size, y * @cell_size, @cell_size, @cell_size
    end
  end
  @z_value += 1
end

def make_fire
  (width / @cell_size).times do |x|
    (height / @cell_size).times do |y|
      nx = (x) * @noise_scale
      ny = (@xy_offset + y) * @noise_scale
      nz = @z_value * @noise_scale
      fill 255 * noise(nx, ny, nz), 0, 0
      rect x * @cell_size, y * @cell_size, @cell_size, @cell_size
    end
  end

  (width / 16).times do |n|
    image(@img, n * 16, 0)
  end
  @xy_offset += 2
  @z_value += 1
end

# def mouse_moved
#   background 51
#   (width / @cell_size).times do |x|
#     (height / @cell_size).times do |y|
#       nx = (mouseX + x) * @noise_scale
#       ny = (mouseY + y) * @noise_scale
#       fill 255 * noise(nx, ny)
#       rect x * @cell_size, y * @cell_size, @cell_size, @cell_size
#     end
#   end
# end

