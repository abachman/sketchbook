var Art = function(cartridge) {
  this.cartridge = cartridge;
  this.cartridge.set(this.cartridge.id, "hello world, I am "+this.cartridge.id);
  this.ui = cartridge.ui;
  this.canvas  = this.ui.canvas;
  this.context = this.ui.context;
  this.p = new Processing(this.canvas, _.bind(this.attach, this));
}

Art.prototype = {
  attach: function(p) {
    var spheres = {};

    var cartridge = this.cartridge;
    var radius = 50.0;
    var delay = 16;
    var mouseX;
    var mouseY;
    var mousediff = false;

    p.setup = function(){
      p.size( 620, 465 );
      p.strokeWeight( 10 );
      p.frameRate( 24 );
    }

    p.draw = function(){
      radius = radius + p.sin( p.frameCount / 4 );
      p.background( 255 );
      p.fill( 0, 121, 184 );
      p.stroke(192); 

      cartridge.each(function(obj, id) {
        if(!spheres[id]) {
          spheres[id] = {
            x: p.width/2,
            y: p.height/2
          }
        }
        var sphere = spheres[id];
        var nx = obj.nx || sphere.x;
        var ny = obj.ny || sphere.y;

        sphere.x += (nx-sphere.x)/delay;
        sphere.y += (ny-sphere.y)/delay;

        p.ellipse( sphere.x, sphere.y, radius, radius );                  
      });

      if (mousediff) {
        cartridge.set(cartridge.id, {
          nx: mouseX,
          ny: mouseY
        });
        mousediff = false;
      }
    }

    p.mouseMoved = function(){
      if (mouseX !== p.mouseX || mouseY !== p.mouseY) {
        mouseX = p.mouseX;
        mouseY = p.mouseY;
        mousediff = true
      }
    }
  }
};
Cartridge.boot(Art)
