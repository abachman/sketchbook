def setup
  size 640, 480
  background 51
  color_mode HSB
  noStroke
  frameRate 20

  @cell_size = 32

  @noise_scale = 0.03
  @white = color 255

  @z_value = 0

  @xy_offset = 0
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
  step_through_z
end

def step_through_z
  (width / @cell_size).times do |x|
    (height / @cell_size).times do |y|
      nx = (x) * @noise_scale
      ny = (@xy_offset + y) * @noise_scale
      nz = @z_value * @noise_scale
      fill 255 * noise(nx, ny, nz), 255, 255
      rect x * @cell_size, y * @cell_size, @cell_size, @cell_size
    end
  end
  @z_value += 1
  @xy_offset += 1
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

