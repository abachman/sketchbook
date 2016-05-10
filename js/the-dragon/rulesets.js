// some rules taken from
// * http://www.nahee.com/spanky/www/fractint/lsys/plants.html
// * http://en.wikipedia.org/wiki/L-system
var load_rulesets = function (rules) {
  rules.THEDRAGON = {
    /*
      variables : X Y
      constants : F + −
      start     : FX
      rules     : (X → X+YF+), (Y → -FX-Y)
      angle     : 90°
     */
    title: 'THE DRAGON CURVE',
    color: 'rgb(173, 230, 253)',

    axiom: 'FX',
    angle: 90,
    length: 4,
    generations: 12,
    start: {x: 0.5, y: 0.40},

    evolve: {
      'X': 'X+YF+',
      'Y': '-FX-Y',
      'F': 'F'
    },

    render: function (pen, chr) {
      switch(chr) {
        case 'F':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
      }
    }

  };

  rules.THETREE = {
    /*
      variables : 0, 1
      constants : [, ]
      axiom     : 0
      rules     : (1 → 11), (0 → 1[0]0)
     */

    title: 'A SIMPLE TREE',
    color: {r: 162, g: 74, b: 40},

    axiom: '0',
    angle: 45,
    generations: 8,
    length: 2,
    start: {x: 0.5, y: 1, r: Math.PI},
    evolve: {
      '0': '1[-0]+0',
      '1': '11'
    },
    render: function (pen, chr) {
      switch(chr) {
        case 'F':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
        case '[':
          pen.pushState();
          break;
        case ']':
          pen.popState();
          break;
        case '1':
          pen.drawForward();
          break;
        case '0':
          pen.drawForward();
          pen.leaf();
          break;
      }
    }
  };

  rules.THEPLANT = {
    /*
      variables : X F
      constants : + −
      start  : X
      rules  : (X → F-[[X]+X]+F[+FX]-X), (F → FF)
      angle  : 25°
    */

    title: 'AN ORDINARY PLANT',
    color: {r: 74, g: 162, b: 40},

    // axiom: 'X',
    axiom: '++++F',
    angle: 360 / 16,
    generations: 4,
    length: 5,
    start: {x: 0.5, y: 1, r: Math.PI * 1.5},
    evolve: {
      'X': 'F-[[X]+X]+F[+FX]-X',
      'F': 'FF-[-F+F+F]+[+F-F-F]'
    },

    render: function (pen, chr) {
      switch(chr) {
        case 'F':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
        case '[':
          pen.pushState();
          break;
        case ']':
          pen.popState();
          break;
      }
    }
  };

  rules.TRIANGLE = {
    /*
      variables : A B
      constants : + −
      start     : A
      rules     : (A → B−A−B), (B → A+B+A)
      angle     : 60°
     */

    title: 'THE SIERPINSKI TRIANGLE',
    color: {r: 40, g: 74, b: 162},

    axiom: 'A',
    angle: 60,
    generations: 8,
    length: 16,
    start: {x: 0.25, y: 0.75, r: Math.PI * 1.5},

    evolve: {
      'A': 'B-A-B',
      'B': 'A+B+A'
    },

    render: function (pen, chr) {
      switch(chr) {
        case 'A':
          pen.drawForward();
          break;
        case 'B':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
      }
    }
  };

  rules.SNOWFLAKE = {
    /*
     axiom : F--F--F
     angle : 60
     rules : (F → F+F--F+F)
     */

    title: 'THE KOCH SNOWFLAKE',
    color: {r: 240, g: 240, b: 240},

    axiom: 'F--F--F',
    angle: 60,
    generations: 5,
    length: 2,
    start: {x: 0.25, y: 0.75, r: Math.PI},

    evolve: {
      'F': 'F+F--F+F'
    },

    render: function (pen, chr) {
      switch(chr) {
        case 'F':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
      }
    }
  }

  rules.HEXAGONAL_GOSPER = {
    /*
     */

    title: 'HEXAGONAL GOSPER CURVE',
    color: {r: 240, g: 240, b: 240},

    axiom: 'XF',
    angle: 60,
    generations: 4,
    length: 500 / Math.pow(3, 4),
    start: {x: 0.25, y: 0.25, r: Math.PI / 2},

    evolve: {
      'F' : 'F',
      'X' : 'X+YF++YF-FX--FXFX-YF+',
      'Y' : '-FX+YFYF++YF+FX--FX-Y',
      '+' : '+',
      '-' : '-'
    },

    render: function (pen, chr) {
      switch(chr) {
        case 'F':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
      }
    }
  };

  rules.HEXADRAGON = {
    /*
     */

    title: 'HEXA-DRAGON',
    color: {r: 240, g: 240, b: 240},

    axiom: 'X',
    angle: 60,
    generations: 10,
    length: 6,
    start: {x: 0.5, y: 0.75, r: Math.PI / 2},

    evolve: {
      'X': 'X+F-F-FY',
      'Y': '-XF+F+FY',
      'F': 'F'
    },

    render: function (pen, chr) {
      switch(chr) {
        case 'F':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
      }
    }
  };

  rules.HEXAGONS = {
    /*
     axiom : F
     angle : 60
     rules : (F → -f+f+g[+f+f]-), (g → gg)

                  -f+f+g[+f+f]-

     The distance between the starting point and ending point of the
     replacement string for 'F' is exactly twice as long as the length
     of each line in the string. Hence the replacement string for 'X'
     must have the same property even though the string 'XX' results in
     nothing being drawn.

     */

    title: 'SMALL BATCH OF HEXAGONS',
    color: 'rgb(100, 100, 100)',

    angle: 60,
    generations: 14,
    length: 300 / 14,
    start: {x: 0.5, y: 0.25},

    axiom: 'x',
    evolve: {
      'f' : 'f',
      'x' : '[-f+f[y]+f][+f-f[x]-f]',
      'y' : '[-f+f[y]+f][+f-f-f]',
    },

    render: function (pen, chr) {
      switch(chr) {
        case 'f':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
        case '[':
          pen.pushState();
          break;
        case ']':
          pen.popState();
          break;
      }
    }
  }

  rules.CROSSES = {
    title: 'THE CROSS TILING',
    color: 'rgb(241, 237, 169)',
    axiom: 'FX',
    angle: 90,
    generations: 6,
    length: 3,
    start: {x: 0.5, y: 0.5},
    evolve: {
      'X': 'FX+FX+FXFY-FY-',
      'Y': '+FX+FXFY-FY-FY',
      'F': ''
    },
    render: function (pen, chr) {
      switch(chr) {
        case 'F':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
      }
    }
  }

  rules.FRACTAL_PLANT = {
    title: 'FRACTAL PLANT',
    color: 'rgb(255, 144, 255)',
    axiom: 'X',
    angle: 25,
    generations: 6,
    length: 4,
    start: {x: 0.5, y: 1, r: Math.PI},
    evolve: {
      'X': 'F-[[X]+X]+F[+FX]-X',
      'F': 'FF'
    },
    render: function (pen, chr) {
      switch(chr) {
        case 'F':
          pen.drawForward();
          break;
        case '-':
          pen.turnLeft();
          break;
        case '+':
          pen.turnRight();
          break;
        case '[':
          pen.pushState();
          break;
        case ']':
          pen.popState();
          break;
      }
    }
    // variables : X F
    // constants : + − [ ]
    // start  : X
    // rules  : (X → F-[[X]+X]+F[+FX]-X), (F → FF)
    // angle  : 25°

  }
}

