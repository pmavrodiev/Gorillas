class window.GhostsAndMonstersGame
  # to set up Easel-Box2d world
  PIXELS_PER_METER = 20
  gravityX = 0
  gravityY = 10
  # game-specific
  frameRate = 60
  forceMultiplier = 5 
  
  $(document).ready -> 
    canvas = document.getElementById('easelCanvas')
    debugCanvas = document.getElementById('debugCanvas')
    statsCanvas = document.getElementById('stats')
    new GhostsAndMonstersGame(canvas, debugCanvas, statsCanvas);
  
  reset: () ->
    alert(window.innerWidth)
    
  constructor: (canvas, debugCanvas, statsCanvas) ->
    g = new Graphics()    
    @world = new EaselBoxWorld(this, frameRate, canvas, debugCanvas, gravityX, gravityY, PIXELS_PER_METER)
    
    @world.addLandscape(
      width:canvas.width,
      height:canvas.height,
      iterations:8,
      smoothness:0.05,
      vertical_offset: canvas.height-150
      type: 'static'
    )
    
    @monkey1 = @world.addMonkey(
      imgSrc: '/img/gorilla_left.png',
      scaleX: 0.3,
      scaleY: 0.3,
      #sizes (=half the side length of the respective square) in pixels. 
      #Coordinates of the body parts are relative to the location of the torso
      size_head:      15,
      size_torso:     20,
      size_lowerbody: 22,
      density: 2,
      friction: 0.8,
      restitution: 0.3,
      #location of the torso's center in pixels
      xPixels: 25, 
      yPixels: 300,
      regX: 60,
      regY: 190
    ) 
    
   
    @monkey2 = @world.addMonkey(
      imgSrc: '/img/gorilla_right.png',
      scaleX: 0.3,
      scaleY: 0.3,
      #sizes (=half the side length of the respective square) in pixels. 
      #Coordinates of the body parts are relative to the location of the torso
      size_head:      15,
      size_torso:     20,
      size_lowerbody: 22,
      density: 2,
      friction: 0.8,
      restitution: 0.3,
      #location of the torso's center in pixels
      xPixels: 745, 
      yPixels: 300,
      regX:230,
      regY:190
    ) 
    
    @arrow = @world.addArrow(
      xPixels: 100,
      yPixels:100
      #6 points: format: [x1,y1,x2,y2,x3,y3,x4,y4,x5,y5]
      ###
      The arrow is sketched below. Lettered points are the ones actually drawn in alphabetical order(i.e. A-F)
      The X-es are shown for illustration only. 
      Coordinates are A = (x1,y1), B = (x2,y2) and so on. The last point is F = (x6,y6) 
                                                 E
                                                 D    X
                                       X                 X
                             X                              X
                   X                                           X    
       A                                                          F    
                   X                                           X    
                             X                              X           
                                       X                 X  
                                                 B   X
                                                 C
                                            
       
       
      ###
      shape_coordinates: [100,100,
                          170,110,
                          170,115,
                          170,90
                          170,85,
                          190,100],
      rotation: 45
    )
    
    
    
    # optional: set up frame rate display
    @stats = new Stats()
    statsCanvas.appendChild @stats.domElement
    
 
   
  # optional: a callback for each EaselBox2dWorld tick()
  tick: () ->
    #@monkey1.ApplyForce(@world.box2dWorld.GetGravity());  
    @stats.update()
    
                  