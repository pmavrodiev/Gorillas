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
    @world.addLandscape(width:canvas.width,height:canvas.height)
    # optional: set up frame rate display
    @stats = new Stats()
    statsCanvas.appendChild @stats.domElement
    
    worldWidthPixels = canvas.width
    worldHeightPixels = canvas.height
    initHeadXPixels = 140
    groundLevelPixels = worldHeightPixels - (37/2)
    
    
    #@world.addImage("/img/sky.jpg", {scaleX: 1.3, scaleY: 1.7})    
    #@world.addImage("/img/trees.png", {scaleX: 0.5, scaleY: 0.9, y: worldHeightPixels - 700 * 0.55})
    #@world.addImage("/img/mountains.png", {scaleX: 1, scaleY: 1, y: worldHeightPixels - 254 * 1})
    #@world.addImage("/img/catapult_50x150.png", {x: initHeadXPixels - 10, y:  worldHeightPixels - 160})    
    ###
    ground = @world.addEntity(
      widthPixels: 1540,
      heightPixels: 37,
      imgSrc: '/img/ground-cropped.png',
      type: 'static',
      xPixels: 0, 
      yPixels: groundLevelPixels)      
    
    # setup head
    @head = @world.addEntity(
      radiusPixels: 20,
      imgSrc: '/img/mz.png',
      type: 'static',
      xPixels: initHeadXPixels, 
      yPixels: groundLevelPixels - 140,
      motionRadiusPixels = 100
      ) 
 
    @head.selected = false
    @head.easelObj.onPress = (eventPress) =>
      @head.selected = true
      #@head.initPositionXpixels = eventPress.stageX
      #@head.initPositionYpixels = eventPress.stageY
      @head.initPositionXpixels = initHeadXPixels
      @head.initPositionYpixels = groundLevelPixels - 140
     
      
      eventPress.onMouseMove = (event) =>
        #are on the left side of the bounding circle?
         if Math.pow(event.stageX-@head.initPositionXpixels,2)+Math.pow(event.stageY-@head.initPositionYpixels,2) <= Math.pow(motionRadiusPixels,2)
            deltaX = event.stageX-@head.initPositionXpixels
            if (deltaX <=0)
              @head.setState(xPixels: event.stageX, yPixels: event.stageY)  
    
      eventPress.onMouseUp = (event) =>
        @head.selected = false
        @head.setType "dynamic"
        #helpful function
        sgn = (x) ->
          if x>0 
            1 
          else if x<0  
            -1
          else  
            0   
        
        #alert("x origin "+@head.initPositionXpixels)
        #alert("y origin "+@head.initPositionYpixels)
        #alert("x event " + event.stageX)
        #alert("y event " + event.stageY)
        #are we inside the bounding circle?
        deltaX = event.stageX-@head.initPositionXpixels
        deltaY = event.stageY-@head.initPositionYpixels
        if Math.pow(deltaX,2)+Math.pow(deltaY,2) > Math.pow(motionRadiusPixels,2)
          #the angle of the mouseup point with the x-axis          
          theta=Math.atan(Math.abs(deltaY/deltaX))          
          #alert("angle "+ theta*180/Math.PI + " degrees")
          
          
          event.stageX=Math.cos(theta)*motionRadiusPixels*sgn(deltaX)+@head.initPositionXpixels
          event.stageY=Math.sin(theta)*motionRadiusPixels*sgn(deltaY)+@head.initPositionYpixels
          #bound to left semi-circle
          event.stageX = Math.min(event.stageX,@head.initPositionXpixels)
        #alert("x event post " + event.stageX)
        #alert("y event post " + event.stageY)  
        forceX = (@head.initPositionXpixels - event.stageX) * forceMultiplier
        forceY = (@head.initPositionYpixels - event.stageY) * forceMultiplier
        @head.body.ApplyImpulse(
          @world.vector(forceX, forceY),
          @world.vector(@head.body.GetPosition().x, @head.body.GetPosition().y)
        )
 
    # draw pyramid    
    @drawPyramid(groundLevelPixels)
    ###
    
  drawPyramid: (groundLevelPixels) ->
    blockWidth = 15 
    blockHeight = 60 
    leftPyamid = 500
    levels = 4

    topOfPyramid = groundLevelPixels - levels *  (blockHeight + blockWidth) + 26
    for i in [0...levels]
      for j in [0..i+1]
          x =  leftPyamid + (j-i/2) * blockHeight 
          y = topOfPyramid + i * (blockHeight + blockWidth)
          myBlock =  @world.addEntity(
            widthPixels: blockWidth,
            heightPixels: blockHeight,
            imgSrc: '/img/block1_15x60.png',
            xPixels: x, 
            yPixels: y)        

          if j <= i
            myBlock = @world.addEntity(
              widthPixels: blockWidth,
              heightPixels: blockHeight,
              imgSrc: '/img/block1_15x60.png',             
              xPixels: x + blockHeight / 2,
              yPixels: y - (blockHeight + blockWidth) / 2
              angleDegrees: 90)

            ghost = @world.addEntity(
              widthPixels: 30,
              heightPixels: 36,
              imgSrc: '/img/enemy.png',
              xPixels: x + (blockHeight / 2),
              yPixels: y + 11)
  
    
   
  # optional: a callback for each EaselBox2dWorld tick()
  tick: () ->
    @stats.update()
    
                  