class window.GhostsAndMonstersGame
  # to set up Easel-Box2d world
  PIXELS_PER_METER = 10
  gravityX = 0
  gravityY = 10
  # game-specific
  frameRate = 60
  forceMultiplier = 5 
  
  $(document).ready -> 
     canvas = document.getElementById('easelCanvas')
     debugCanvas = document.getElementById('debugCanvas')
     statsCanvas = document.getElementById('stats')
     pw = canvas.parentNode.clientWidth
     ph = canvas.parentNode.clientHeight
     canvas.height = pw * 0.9 * (canvas.height/canvas.width)  
     canvas.width = pw * 0.9
     canvas.style.top = (ph-canvas.height)/2 + "px"
     canvas.style.left = (pw-canvas.width)/2 + "px"
     debugCanvas.height = pw * 0.9 * (debugCanvas.height/debugCanvas.width)  
     debugCanvas.width = pw * 0.9
     debugCanvas.style.top = (ph-debugCanvas.height)/2 + "px"
     debugCanvas.style.left = (pw-debugCanvas.width)/2 + "px"    
     new GhostsAndMonstersGame(canvas, debugCanvas, statsCanvas)
  
  reset: () ->
    alert(window.height)
    
  constructor: (canvas, debugCanvas, statsCanvas) ->
    @voffset = canvas.height*0.85
   
    @world = new EaselBoxWorld(this, frameRate, canvas, debugCanvas, gravityX, gravityY, PIXELS_PER_METER)
    
    @world.addLandscape(
      width:canvas.width,
      height:canvas.height,
      iterations:8,
      smoothness:0.05,
      vertical_offset:  @voffset
      type: 'static'
    )
    
    @banana = @world.addBanana(
      imgSrc: "/img/BANANA/banana.png"
      scaleX: 0.06,
      scaleY: 0.06,
      density: 2,
      friction: 0.8,
      restitution: 0.3,
      #dimensions of the  Box2D rectangle in pixels 
      width: 20,
      height: 40,
      #the position of the easeljs object
      xPixels: 80, 
      yPixels: 300,
    )
    
    @monkey1 = @world.addMonkey(
      SpriteSheet:  new SpriteSheet(
        images: ["/img/BREATH2/left/breath_left_1.png","/img/BREATH2/left/breath_left_2.png","/img/BREATH2/left/breath_left_3.png","/img/BREATH2/left/breath_left_4.png","/img/BREATH2/left/breath_left_5.png"],
        frames: {width:800,height:600}
        animations: {standby:[0,4,"standby",5]}      
        ),     
      scaleX: 0.3,
      scaleY: 0.3,
      #sizes (=half the side length of the respective square) in pixels. 
      #Coordinates of the body parts are relative to the location of the torso
      size_head:      20,
      size_torso:     25,
      size_lowerbody: 32,
      density: 2,
      friction: 0.8,
      restitution: 0.3,
      #location of the torso's center in pixels
      xPixels: 75, 
      yPixels: @voffset-5,
      #for the easel object. 
      regX: 110,
      regY: 550
    ) 
  
    @box = @world.addBox(
      imgSrc: "/img/BOX/box.png"
      scaleX: 1,
      scaleY: 1,    
      #the position of the easeljs object
      xPixels: 8, 
      yPixels: @voffset-65,       
    )
    
    
    @monkey2 = @world.addMonkey(
      SpriteSheet:  new SpriteSheet(
        images: ["/img/BREATH/right_breath1-resized.png","/img/BREATH/right_breath2-resized.png","/img/BREATH/right_breath3-resized.png","/img/BREATH/right_breath4-resized.png"],
        frames: {width:308,height:308}
        animations: {standby:[0,3,"standby",5]}      
        ),  
      scaleX: 0.5,
      scaleY: 0.5,
      #sizes (=half the side length of the respective square) in pixels. 
      #Coordinates of the body parts are relative to the location of the torso
      size_head:      15,
      size_torso:     20,
      size_lowerbody: 22,
      density: 2,
      friction: 0.8,
      restitution: 0.3,
      #location of the torso's center in pixels
      xPixels: canvas.width-22-38, 
      yPixels: @voffset-20-22*2,
      regX:308/2,
      regY:308/2+20,
      #location of the easel object
      easelx: 100,
      easely: 100
    ) 
   
   
    @bazooka = @world.addBazooka(
      imgSrc: "/img/BAZOOKA/Bazooka.png"
      scaleX: 1,
      scaleY: 1,
      density: 2,
      friction: 0.8,
      restitution: 0.3,
      #dimensions of the  Box2D rectangle in pixels 
      width: 40,
      height: 125,
      #the position of the easeljs object
      xPixels: 120, 
      yPixels: 120,       
      regX: 25.5,
      regY: 128-1.92,
      angleDegrees: 0
    )
    
    
    
    #@arrow = @world.addArrow(
     # xPixels: 100,
     # yPixels:100
      #6 points: format: [x1,y1,x2,y2,x3,y3,x4,y4,x5,y5]     
      #The arrow is sketched below. Lettered points are the ones actually drawn in alphabetical order(i.e. A-F)
      #The X-es are shown for illustration only. 
      #Coordinates are A = (x1,y1), B = (x2,y2) and so on. The last point is F = (x6,y6) 
      #                                           E
      #                                           D    X
      #                                 X                 X
      #                       X                              X
      #             X                                           X    
      # A                                                          F    
      #             X                                           X    
      #                       X                              X           
      #                                 X                 X  
      #                                           B   X
      #                                           C
      #                                     
      # 
      #       
      #shape_coordinates: [100,100,
      #                    170,110,
      #                    170,115,
      #                    170,90
      #                    170,85,
      #                    190,100],
      #rotation: 45
      #)
    
    
    ###
    # optional: set up frame rate display
    #@stats = new Stats()
    #statsCanvas.appendChild @stats.domElement
    
  # optional: a callback for each EaselBox2dWorld tick()
  tick: () ->
    #@monkey1.ApplyForce(@world.box2dWorld.GetGravity());  
    #@stats.update()
    
                  