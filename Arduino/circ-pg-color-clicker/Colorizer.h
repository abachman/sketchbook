#ifndef COLORIZER_H
#define COLORIZER_H

#include <Adafruit_CircuitPlayground.h>

#define COLOR uint32_t
#define TIME  unsigned long

uint32_t Color(uint8_t r, uint8_t g, uint8_t b) {
  return r * 0x010000 + g * 0x000100 + b * 0x000001;
}

// Returns the Red component of a 32-bit color
uint8_t Red(uint32_t color)
{
  return (color >> 16) & 0xFF;
}

// Returns the Green component of a 32-bit color
uint8_t Green(uint32_t color)
{
  return (color >> 8) & 0xFF;
}

// Returns the Blue component of a 32-bit color
uint8_t Blue(uint32_t color)
{
  return color & 0xFF;
}

static int dimRate = 3;

uint8_t DimBy(uint8_t c, uint8_t by) {
  uint8_t n = (c - by);
  if (n > c) {
    return 0;
  } else {
    return n;
  }
}

uint8_t Dim(uint8_t c) {
  return DimBy(c, dimRate);
}


// Return color, dimmed
uint32_t DimColor(uint32_t color) {
  return Color(Dim(Red(color)), Dim(Green(color)), Dim(Blue(color)));
}

uint32_t DimColorBy(uint32_t color, uint8_t by) {
  return Color(DimBy(Red(color), by), DimBy(Green(color), by), DimBy(Blue(color), by));
}


class Colorizer {
  public:
    COLOR current;

    // animation
    int isOn = 0;
    TIME lastStep;
    TIME stepDelay = 70;

    unsigned long index;
    COLOR color;

    // FLASH MODE
    bool isFlashing;
    COLOR flash;
    TIME startedAt;
    TIME flashLen;

    Colorizer() {
      initialize();
    }

    void initialize() {
      index = 0;
      color = pick();
    }

    COLOR mc(COLOR c, double multiplier) {
      return Color(
        (COLOR)((double)(Red(c)) * multiplier),
        (COLOR)((double)(Green(c)) * multiplier),
        (COLOR)((double)(Blue(c)) * multiplier)
      );
    }

    void set(COLOR c) {
      CircuitPlayground.clearPixels();

      if (isFlashing) {
        // set all
        for (int p=0; p < 10; p++) {
          CircuitPlayground.setPixelColor(p, c);
        }
      } else {
        // chase 
        int steps = 5;
        COLOR nc;
        for (int p=0; p < steps; p++) {
          nc = c;
          for (int q=0; q < (steps - p); q++) {
            nc = mc(nc, 0.6);
          }
          CircuitPlayground.setPixelColor((isOn + p) % 10, nc);
        }
      }

      if ((millis() - lastStep) > stepDelay) {
        isOn = (isOn + 1)  % 10;
        lastStep = millis();
      }

      CircuitPlayground.strip.show();
    }

    void start() {
      CircuitPlayground.setPixelColor(2, 0xFF0000);
      CircuitPlayground.setPixelColor(7, 0x0000FF);
    }

    void update() {
      if (isFlashing) {
        flash = DimColor(flash);
      }
    }

    void draw() {
      COLOR nc;

      if (isFlashing) {
        nc = flash;
      } else {
        nc = color;
      }

      if (current != nc) {
        set(nc);
      }
    }

    void startFlash(unsigned long timeoutMs) {
      // default to bright white
      startFlash(timeoutMs, 0xFFFFFF);
    }

    void startFlash(unsigned long timeoutMs, COLOR sc) {
      isFlashing = true;
      flash = sc;
      startedAt = millis();
      flashLen = timeoutMs;
    }

    bool flashing() {
      if (isFlashing) {
        if ((millis() - startedAt) < flashLen) {
          return true;
        } else { 
          isFlashing = false;
        }
      }

      return false;
    }

    COLOR randomColor() {
      return random(0xFF) * 0x010000 +
             random(0xFF) * 0x000100 +
             random(0xFF) * 0x000001;
    }

    void next() {
      index++;
      color = pick();
    }

    void prev() {
      index--;
      color = pick();
    }

    COLOR pick() {
      return CircuitPlayground.colorWheel((index * 16) & 0xFF);
    }
};

#endif
