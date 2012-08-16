// Generated by CoffeeScript 1.3.3
(function() {

  window.GhostsAndMonstersGame = (function() {
    var PIXELS_PER_METER, forceMultiplier, frameRate, gravityX, gravityY;

    PIXELS_PER_METER = 10;

    gravityX = 0;

    gravityY = 10;

    frameRate = 60;

    forceMultiplier = 5;

    $(document).ready(function() {
      var canvas, debugCanvas, ph, pw, statsCanvas;
      canvas = document.getElementById('easelCanvas');
      debugCanvas = document.getElementById('debugCanvas');
      statsCanvas = document.getElementById('stats');
      pw = canvas.parentNode.clientWidth;
      ph = canvas.parentNode.clientHeight;
      canvas.height = pw * 0.9 * (canvas.height / canvas.width);
      canvas.width = pw * 0.9;
      canvas.style.top = (ph - canvas.height) / 2 + "px";
      canvas.style.left = (pw - canvas.width) / 2 + "px";
      debugCanvas.height = pw * 0.9 * (debugCanvas.height / debugCanvas.width);
      debugCanvas.width = pw * 0.9;
      debugCanvas.style.top = (ph - debugCanvas.height) / 2 + "px";
      debugCanvas.style.left = (pw - debugCanvas.width) / 2 + "px";
      return new GhostsAndMonstersGame(canvas, debugCanvas, statsCanvas);
    });

    GhostsAndMonstersGame.prototype.reset = function() {
      return alert(window.height);
    };

    function GhostsAndMonstersGame(canvas, debugCanvas, statsCanvas) {
      this.voffset = canvas.height * 0.85;
      this.world = new EaselBoxWorld(this, frameRate, canvas, debugCanvas, gravityX, gravityY, PIXELS_PER_METER);
      this.world.addLandscape({
        width: canvas.width,
        height: canvas.height,
        iterations: 8,
        smoothness: 0.05,
        vertical_offset: this.voffset,
        type: 'static'
      });
      this.banana = this.world.addBanana({
        imgSrc: "/img/BANANA/banana.png",
        scaleX: 0.06,
        scaleY: 0.06,
        density: 2,
        friction: 0.8,
        restitution: 0.3,
        width: 20,
        height: 40,
        xPixels: 80,
        yPixels: 300
      });
      this.monkey1 = this.world.addMonkey({
        SpriteSheet: new SpriteSheet({
          images: ["/img/BREATH2/left/breath_left_1.png", "/img/BREATH2/left/breath_left_2.png", "/img/BREATH2/left/breath_left_3.png", "/img/BREATH2/left/breath_left_4.png", "/img/BREATH2/left/breath_left_5.png"],
          frames: {
            width: 800,
            height: 600
          },
          animations: {
            standby: [0, 4, "standby", 5]
          }
        }),
        scaleX: 0.3,
        scaleY: 0.3,
        size_head: 20,
        size_torso: 25,
        size_lowerbody: 32,
        density: 2,
        friction: 0.8,
        restitution: 0.3,
        xPixels: 75,
        yPixels: this.voffset - 5,
        regX: 110,
        regY: 550
      });
      this.box = this.world.addBox({
        imgSrc: "/img/BOX/box.png",
        scaleX: 1,
        scaleY: 1,
        xPixels: 8,
        yPixels: this.voffset - 65
      });
      this.monkey2 = this.world.addMonkey({
        SpriteSheet: new SpriteSheet({
          images: ["/img/BREATH/right_breath1-resized.png", "/img/BREATH/right_breath2-resized.png", "/img/BREATH/right_breath3-resized.png", "/img/BREATH/right_breath4-resized.png"],
          frames: {
            width: 308,
            height: 308
          },
          animations: {
            standby: [0, 3, "standby", 5]
          }
        }),
        scaleX: 0.5,
        scaleY: 0.5,
        size_head: 15,
        size_torso: 20,
        size_lowerbody: 22,
        density: 2,
        friction: 0.8,
        restitution: 0.3,
        xPixels: canvas.width - 22 - 38,
        yPixels: this.voffset - 20 - 22 * 2,
        regX: 308 / 2,
        regY: 308 / 2 + 20,
        easelx: 100,
        easely: 100
      });
      this.bazooka = this.world.addBazooka({
        imgSrc: "/img/BAZOOKA/Bazooka.png",
        scaleX: 1,
        scaleY: 1,
        density: 2,
        friction: 0.8,
        restitution: 0.3,
        width: 40,
        height: 125,
        xPixels: 120,
        yPixels: 120,
        regX: 25.5,
        regY: 128 - 1.92,
        angleDegrees: 0
      });
      /*
          # optional: set up frame rate display
          #@stats = new Stats()
          #statsCanvas.appendChild @stats.domElement
          
        # optional: a callback for each EaselBox2dWorld tick()
        tick: () ->
          #@monkey1.ApplyForce(@world.box2dWorld.GetGravity());  
          #@stats.update()
      */

    }

    return GhostsAndMonstersGame;

  })();

}).call(this);
