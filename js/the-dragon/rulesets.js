// some rules taken from
// * http://www.nahee.com/spanky/www/fractint/lsys/plants.html
// * http://en.wikipedia.org/wiki/L-system
(function (rules) {
  rules.DRAGON_RULES = {
    /*
      variables : X Y
      constants : F + −
      start     : FX
      rules     : (X → X+YF+), (Y → -FX-Y)
      angle     : 90°
     */
    title: "THE DRAGON CURVE",
    color: {r: 173, g: 230, b: 253},

    axiom: "FX",
    angle: 90,
    length: 4,
    generations: 16,
    start: {x: 0.5, y: 0.30},
    evolve: function (c) {
      switch (c) {
        case "X": return "X+YF+";
        case "Y": return "-FX-Y";
        case "F": return "";
      }
    },
    render: function (pen, chr) {
      switch(chr) {
        case "F":
          pen.drawForward();
          break;
        case "-":
          pen.turnLeft();
          break;
        case "+":
          pen.turnRight();
          break;
      }
    }

  };

  rules.TREE_RULES = {
    /*
      variables : 0, 1
      constants : [, ]
      axiom     : 0
      rules     : (1 → 11), (0 → 1[0]0)
     */

    title: "A SIMPLE TREE",
    color: {r: 162, g: 74, b: 40},

    axiom: "0",
    angle: 45,
    generations: 8,
    length: 2,
    start: {x: 0.5, y: 1, r: Math.PI},
    evolve: function (c) {
      switch (c) {
        case "0": return "1[-0]+0";
        case "1": return "11";
      }
    },
    render: function (pen, chr) {
      switch(chr) {
        case "F":
          pen.drawForward();
          break;
        case "-":
          pen.turnLeft();
          break;
        case "+":
          pen.turnRight();
          break;
        case "[":
          pen.pushState();
          break;
        case "]":
          pen.popState();
          break;
        case "1":
          pen.drawForward();
          break;
        case "0":
          pen.drawForward();
          pen.leaf();
          break;
      }
    }
  };

  rules.PLANT_RULES = {
    /*
      variables : X F
      constants : + −
      start  : X
      rules  : (X → F-[[X]+X]+F[+FX]-X), (F → FF)
      angle  : 25°
    */

    title: "AN ORDINARY PLANT",
    color: {r: 74, g: 162, b: 40},

    // axiom: "X",
    axiom: '++++F',
    angle: 360 / 16,
    generations: 4,
    length: 5,
    start: {x: 0.5, y: 1, r: Math.PI * 1.5},
    evolve: function (c) {
      switch (c) {
        case "X": return "F-[[X]+X]+F[+FX]-X";
        case "F": return 'FF-[-F+F+F]+[+F-F-F]';
        // case "F": return "FF";
      }
    },

    render: function (pen, chr) {
      switch(chr) {
        case "F":
          pen.drawForward();
          break;
        case "-":
          pen.turnLeft();
          break;
        case "+":
          pen.turnRight();
          break;
        case "[":
          pen.pushState();
          break;
        case "]":
          pen.popState();
          break;
      }
    }
  };

  rules.TRIANGLE_RULES = {
    /*
      variables : A B
      constants : + −
      start     : A
      rules     : (A → B−A−B), (B → A+B+A)
      angle     : 60°
     */

    title: "THE SIERPINSKI TRIANGLE",
    color: {r: 40, g: 74, b: 162},

    axiom: "A",
    angle: 60,
    generations: 8,
    length: 2,
    start: {x: 0.25, y: 0.75, r: Math.PI * 1.5},

    evolve: function (c) {
      switch (c) {
        case "A": return "B-A-B";
        case "B": return "A+B+A";
      }
    },

    render: function (pen, chr) {
      switch(chr) {
        case "A":
          pen.drawForward();
          break;
        case "B":
          pen.drawForward();
          break;
        case "-":
          pen.turnLeft();
          break;
        case "+":
          pen.turnRight();
          break;
      }
    }
  };

  rules.SNOWFLAKE_RULES = {
    /*
     axiom : F--F--F
     angle : 60
     rules : (F → F+F--F+F)
     */

    title: "THE KOCH SNOWFLAKE",
    color: {r: 240, g: 240, b: 240},

    axiom: "F--F--F",
    angle: 60,
    generations: 5,
    length: 2,
    start: {x: 0.25, y: 0.75, r: Math.PI},

    evolve: function (c) {
      switch (c) {
        case "F":
          return "F+F--F+F";
      }
    },

    render: function (pen, chr) {
      switch(chr) {
        case "F":
          pen.drawForward();
          break;
        case "-":
          pen.turnLeft();
          break;
        case "+":
          pen.turnRight();
          break;
      }
    }
  }

  //  int generations = 6;                    // set no of recursions
  //  axiom = "X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X";
  //  grammar = new SimpleGrammar(this, axiom);  // initialize custom library
  //  grammar.addRule('X', "[F+F+F+F[3-X-Y]5+F8+F-F-F-F]");
  //  grammar.addRule('Y', "[F+F+F+F[3-Y]5+F8+F-F-F-F]");
  //  startLength = 800;
  //  production = grammar.createGrammar(generations);
  //  drawLength = startLength * pow(0.5, generations);

  rules.TILING_RULES = {
    /*
     axiom : F--F--F
     angle : 60
     rules : (F → F+F--F+F)
     */

    title: "THE KOCH SNOWFLAKE",
    color: {r: 240, g: 240, b: 240},

    axiom: "X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X",
    angle: 60,
    generations: 5,
    length: 2,
    start: {x: 0.25, y: 0.75},

    evolve: function (c) {
      switch (c) {
        case "X": return '[F+F+F+F[3-X-Y]5+F8+F-F-F-F]';
        case "Y": return '[F+F+F+F[3-Y]5+F8+F-F-F-F]';
      }
    },

    render: function (pen, chr) {
      switch(chr) {
        case "F":
          pen.drawForward();
          break;
        case "-":
          pen.turnLeft();
          break;
        case "+":
          pen.turnRight();
          break;
      }
    }
  };

  rules.HEXAGON_RULES = {
    /*
     axiom : F
     angle : 60
     rules : (F → -f+f+g[+f+f]-), (g → gg)

                  -f+f+g[+f+f]-

     The distance between the starting point and ending point of the
     replacement string for "F" is exactly twice as long as the length
     of each line in the string. Hence the replacement string for "X"
     must have the same property even though the string "XX" results in
     nothing being drawn.

     */

    title: "FIELD OF HEXAGONS",
    color: 'rgb(100, 100, 100)',

    axiom: "F",
    angle: 60,
    generations: 7,
    length: 10,
    start: {x: 0.25, y: 0.75},

    evolve: function (c) {
      switch (c) {
        case "f": return '-f+f+g[+f+f]-';
        case "g": return 'gg';
      }
    },

    render: function (pen, chr) {
      switch(chr) {
        case "f":
          pen.drawForward();
          break;
        case "-":
          pen.turnLeft();
          break;
        case "+":
          pen.turnRight();
          break;
        case "[":
          pen.pushState();
          break;
        case "]":
          pen.popState();
          break;
      }
    }
  }

  rules.CROSS_RULES = {
    title: "THE CROSS TILING",
    color: 'rgb(241, 237, 169)',
    axiom: 'FX',
    angle: 90,
    generations: 7,
    length: 3,
    start: {x: 0.5, y: 0.5},
    evolve: function (c) {
      switch (c) {
        case "X": return "FX+FX+FXFY-FY-";
        case "Y": return "+FX+FXFY-FY-FY";
        case "F": return "";
      }
    },
    render: function (pen, chr) {
      switch(chr) {
        case "F":
          pen.drawForward();
          break;
        case "-":
          pen.turnLeft();
          break;
        case "+":
          pen.turnRight();
          break;
      }
    }

  }

})(window);

