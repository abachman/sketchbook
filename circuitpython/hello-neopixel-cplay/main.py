import neopixel
import board
import time
np = neopixel.NeoPixel(board.NEOPIXEL, 10)
c = 0
while True:
    c = (c + 1) % 255
    np.fill((c, 0, 0))
    np.write()
    time.sleep(0.01)
