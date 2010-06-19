#
# Frame Differencing
# by Golan Levin.
#
# GSVideo version by Andres Colubri.
#
# Quantify the amount of movement in the @video frame using frame-differencing.

load_java_library :gsvideo
include_package 'codeanticode.gsvideo'
# import 'codeanticode.gsvideo'

@numPixels = 0
@referenceFrame = []
@threshold = 120
@loaded = false
@bg = nil
@video = nil

def setup
  size(640, 480) # Change size to 320 x 240 if too slow at 640 x 480
  # Uses the default @video input, see the reference if this causes an error
  @video = GSCapture.new(self, width, height, "/dev/video0", 24)
  @numPixels = @video.width * @video.height
  # Create an array to store the previously captured frame
  @referenceFrame = []
  @numPixels.times { @referenceFrame << 0 }
  load_pixels
end

pcount = 0
def draw
  if (@video.available())
    # When using @video to manipulate the screen, use @video.available() and
    # @video.read() inside the draw() method so that it's safe to draw to the screen
    @video.read() # Read the new frame from the camera
    @video.loadPixels() # Make its pixels[] array available

    if (!@loaded)
      @numPixels.times do |n| # For each pixel in the @video frame...
        currColor = @video.pixels[n]
        @referenceFrame[n] = currColor
        pixels[n] = currColor
      end
      @loaded = true
      update_pixels
      puts ("Loaded referenceFrame")
    end

    background(0)
    image(@bg, 0, 0)
    movementSum = 0 # Amount of movement in the frame
    @numPixels.times do |i|
      currColor = @video.pixels[i]
      prevColor = @referenceFrame[i]
      # Extract the red, green, and blue components from current pixel
      currR = (currColor >> 16) & 0xFF # Like red(), but faster
      currG = (currColor >> 8) & 0xFF
      currB = currColor & 0xFF
      # Extract red, green, and blue components from previous pixel
      prevR = (prevColor >> 16) & 0xFF
      prevG = (prevColor >> 8) & 0xFF
      prevB = prevColor & 0xFF
      # Compute the difference of the red, green, and blue values
      diffR = abs(currR - prevR)
      diffG = abs(currG - prevG)
      diffB = abs(currB - prevB)

      if (diffR + diffB + diffG > @threshold)
        pixels[i] = currColor
        pcount += 1
      else
        pixels[i] = color(0,30)
        pixels[i] = get(@bg, int(i % height), int(i / height))
      end
    end
    pcount = 0

    updatePixels()
  end
end

