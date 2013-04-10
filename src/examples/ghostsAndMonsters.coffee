class window.GhostsAndMonstersGame
  # to set up Easel-Box2d world
  PIXELS_PER_METER = 22
  gravityX = 0
  gravityY = 10
  # game-specific
  frameRate = 25
  forceMultiplier = 7 
  
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
     myAudio = document.createElement("audio")
     background = new Audio()   
     audioExtension = ".none"
     if myAudio.canPlayType 
        #Currently canPlayType(type) returns: "", "maybe" or "probably" 
        canPlayMp3 = !!myAudio.canPlayType && "" != myAudio.canPlayType('audio/mpeg')
        canPlayOgg = !!myAudio.canPlayType && "" != myAudio.canPlayType('audio/ogg; codecs="vorbis"');
     if canPlayMp3
        audioExtension = ".mp3"
     else if canPlayOgg
        audioExtension = ".ogg"
     
     background.src = "/sounds/background-music"+audioExtension
     background.loop = true
     background.autoplay = true       
    
     
     
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
    
    @world.addBanana(
      imgSrc: "/img/BANANA/banana.png"
      scaleX: 1,
      scaleY: 1,
      density: 1,
      friction: 0,
      restitution: 0,
      #dimensions of the  Box2D rectangle in pixels 
      width: 40,
      height: 20,
      #the position of the easeljs object
      #xPixels: (muzzle x coord. of bazooka - monkey.regX)*monkey.scaleX + monkey.xPixels
      xPixels: (625-110)*0.3 + 75
      #yPixels: (monkey.yPixels-5)-(monkey.regY-muzzle y coord. of bazooka)*monkey.scaleY
      yPixels: (@voffset-5) - (550-240)*0.3
      regX: 20,
      regY: 20,
    )
    
    @monkey1 = @world.addMonkey(
      SpriteSheet:  new SpriteSheet(
        images: ["/img/BREATH3/left/breath_left_1.png",
                 "/img/BREATH3/left/breath_left_2.png",
                 "/img/BREATH3/left/breath_left_2_copy.png",
                 "/img/BREATH3/left/breath_left_3.png",
                 "/img/BREATH3/left/breath_left_3_copy.png",
                 "/img/BREATH3/left/breath_left_4.png",
                 "/img/BREATH3/left/breath_left_4_copy.png",
                 "/img/BREATH3/left/breath_left_5.png",
                 "/img/BREATH3/left/approach-left-1.png",
                 "/img/BREATH3/left/approach-left-1_copy.png",
                 "/img/BREATH3/left/approach-left-2.png"
                 "/img/BREATH3/left/approach-left-2_copy.png",
                 "/img/BREATH3/left/approach-left-3.png"
                 "/img/BREATH3/left/approach-left-3_copy.png",
                 "/img/BREATH3/left/approach-left-4.png"
                 "/img/BREATH3/left/approach-left-4_copy.png",
                 "/img/BREATH3/left/approach-left-5.png"
                 "/img/BREATH3/left/approach-left-5_copy.png",
                 "/img/BREATH3/left/approach-left-6.png",
                 "/img/BREATH3/left/shoot_left_1.png"
                 "/img/BREATH3/left/shoot_left_2.png"
                 ],
        frames: {width:220,height:165, count:21}
        animations: {
                     standby:[0,7,"standby",2],
                     approachbazooka:[7,18,false,1],
                     shoot:[18,20,false,1]
                     }      
        ),     
      scaleX: 1,
      scaleY: 1,
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
      yPixels: @voffset-75,
      #for the easel object. 
      regX: 33,#110,
      regY: 165-15,#550,
      voffset: @voffset
    ) 
    @monkey1.addActionListeners()
    
    @tower = @world.addTower(
      imgSrc: "/img/TOWER/tower.png"
      scaleX: 0.4,
      scaleY: 0.3,    
      #the position of the easeljs object
      xPixels: 25, 
      yPixels: @voffset-125,       
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
   
    ###
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
      yPixels: 130,       
      regX: 25.5,
      regY: 128-1.92,
      angleDegrees: 0
    )
    ###    
  # optional: a callback for each EaselBox2dWorld tick()
  tick: () ->
    for i in @world.contactlistener.contacts       
        if (i.fixtureA == @world.banana.fixture and i.fixtureB == @monkey2.headbodyfixture) or
           (i.fixtureA == @monkey2.headbodyfixture and i.fixtureB == @world.banana.fixture)
              console.log "headshot"     
    #console.log "tick2"
    #@monkey1.ApplyForce(@world.box2dWorld.GetGravity());  
    #@stats.update()
    
                  