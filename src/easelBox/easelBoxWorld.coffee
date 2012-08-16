PIXELS_PER_METER = 10

class window.EaselBoxWorld
  minFPS = 10 # weird stuff happens when we step through the physics when the frame rate is lower than this
  
  constructor: (@callingObj, frameRate, canvas, debugCanvas, gravityX, gravityY, @pixelsPerMeter) -> 
    PIXELS_PER_METER = @pixelsPerMeter
      
    #this static class comes from easelsj
    Ticker.addListener this # set up timing loop -- obj must supply a tick() method
    Ticker.setFPS frameRate
                 
    # set up Box2d
    @box2dWorld = new Box2D.Dynamics.b2World(new Box2D.Common.Math.b2Vec2(gravityX, gravityY), true)

    # set up EaselJS
    @easelStage = new Stage(canvas)    
    # array of entities to update later
    @objects = []

    # Set up Box2d debug drawing
    debugDraw = new Box2D.Dynamics.b2DebugDraw()
    debugDraw.SetSprite debugCanvas.getContext("2d")
    debugDraw.SetDrawScale @pixelsPerMeter
    debugDraw.SetFillAlpha 0.3
    debugDraw.SetLineThickness 2.0
    debugDraw.SetFlags Box2D.Dynamics.b2DebugDraw.e_shapeBit | Box2D.Dynamics.b2DebugDraw.e_jointBit | Box2D.Dynamics.b2DebugDraw.e_centerOfMassBit
    @box2dWorld.SetDebugDraw debugDraw 

  addLandscape: (options) ->
    #how much flat land should we dedicate to each gorilla?   
    @flatLand=40
    #generate a random landscape via the midpoint displacement method
    #@height_offset - the base line for the landscape
    #min/max_width - the left and right boundaries of the canvas
    #iterations - # of iterations for the algorithm
    #r - roughness of the generated landscape
    @height_offset = options.vertical_offset #in pixels
    min_width = 0; max_width = options.width
    iterations = options.iterations; r = options.smoothness
    @height = options.height
    #custom data type
    class bound
       #min_/max_ idx - the left and right indeces of the landscape range
       #iteration - which iteration of the algorithm this range belongs to
       constructor: (min_idx,max_idx,iteration) ->
         @min_idx = min_idx; @max_idx = max_idx; @iteration = iteration
    
    min = -80; max = 50 #random number range
    ticks = Math.pow(2,iterations)     
    #bin_size = (max_width - min_width) / ticks
    @vpoints_vector = new Array(ticks+1)
    @vpoints_vector[0] = new Array(2); @vpoints_vector[ticks] = new Array(2)
    @vpoints_vector[0][0] = min_width; @vpoints_vector[0][1] = @height_offset
    @vpoints_vector[ticks][0] = max_width; @vpoints_vector[ticks][1] = @height_offset
    queue = [] 
    queue.push(new bound(0,ticks,1)) #indexed from 0 and first iteration!
    while queue.length > 0      
     #always get the first element
      firstElement = queue.shift()
      left_idx = firstElement.min_idx; right_idx = firstElement.max_idx; iter = firstElement.iteration
      if right_idx - left_idx > 1 #not adjacent indeces
         midpoint_x = (@vpoints_vector[right_idx][0]+@vpoints_vector[left_idx][0]) / 2
         midpoint_y = (@vpoints_vector[right_idx][1]+@vpoints_vector[left_idx][1]) / 2
         if iter > 1            
           min = min*Math.pow(2,-r); max = max*Math.pow(2,-r)
         if iter == 1 #disrupt the first midpoint significantly to get a peak in the middle
           midpoint_y = midpoint_y + Math.random() * (-100 - 5*min) + 5*min; #disturb the y coordinate
         else  
           midpoint_y = midpoint_y + Math.random() * (max - min) + min; #disturb the y coordinate
         
         midpoint_index = (left_idx+right_idx)/2 
         @vpoints_vector[midpoint_index] = new Array(2)
         @vpoints_vector[midpoint_index][0]= midpoint_x
         @vpoints_vector[midpoint_index][1]= midpoint_y       
         #breadth first search style
         queue.push(new bound(left_idx,(right_idx+left_idx)/2,iter+1))
         queue.push(new bound((right_idx+left_idx)/2,right_idx,iter+1))
    
  
     x0=@vpoints_vector[0][0]
     y0=@vpoints_vector[0][1]
     max_y_idx = (@vpoints_vector.length-1)/2 -1
     max_y = @vpoints_vector[max_y_idx][1]
     max_y = @height_offset
     #preload the landscape image
     @landscape = new Shape()
     @img = new Image()
     @img.src="/img/LANDSCAPE/angry.png"   
     @img.onload = () =>     
       @landscape.graphics.beginBitmapFill(@img)
       i = new Image()
       i.src = "/img/LANDSCAPE/grass-texture-0.png"
       @landscape.graphics.setStrokeStyle(8).beginBitmapStroke(i)             
       @landscape.graphics.moveTo(x0,y0)
               
       for i in [1..(@vpoints_vector.length-2)]
          x1 = @vpoints_vector[i][0]; x2 = @vpoints_vector[i+1][0]
          y1 = @vpoints_vector[i][1]; y2 = @vpoints_vector[i+1][1]   
          if (i <= @flatLand or i >= @vpoints_vector.length-1-@flatLand)            
            y1=@vpoints_vector[0][1]
            y2=@vpoints_vector[0][1]       
          #bottom_left to top_left
          @landscape.graphics.lineTo(x2,y2)
          #now close the shape
          if (i == @vpoints_vector.length-2)            
            @landscape.graphics.beginStroke(null)       
            @landscape.graphics.moveTo(x2, y2)        
            @landscape.graphics.lineTo(x2, @height)  
            @landscape.graphics.lineTo(@vpoints_vector[0][0], @height)
            @landscape.graphics.lineTo(@vpoints_vector[0][0], @height_offset)  
        
       @easelStage.addChild @landscape
    
    #Start creating the individual rectangles constituting the landscape
    #It sucks that the current Box2dWeb port does not have the ChainShape shape from the latest Box2D release.
    #Now the landscape needs to be generated as a sequence of tiny rectangles, which is not neat!
    for i in [0..(@vpoints_vector.length-2)]
      x1 = @vpoints_vector[i][0]; x2 = @vpoints_vector[i+1][0]
      y1 = @vpoints_vector[i][1]; y2 = @vpoints_vector[i+1][1]
      if (i <= @flatLand or i >= @vpoints_vector.length-2-@flatLand)
        y1=@vpoints_vector[0][1]
        y2=@vpoints_vector[0][1]
      #add the actual object        
      tinyRectangle = @addEntity(
        whoami: "inefficient rectangle"
        bottom_left_corner:  new Box2D.Common.Math.b2Vec2 x1,@height 
        top_left_corner:     new Box2D.Common.Math.b2Vec2 x1,y1
        top_right_corner:    new Box2D.Common.Math.b2Vec2 x2,y2
        bottom_right_corner: new Box2D.Common.Math.b2Vec2 x2,@height
        type: options.type
      )      

   addBazooka: (options) ->    
    object = new EaselBoxBazooka(options)
    @easelStage.addChild object.easelObj
    object.body = @box2dWorld.CreateBody(object.bodyDef)
    object.body.CreateFixture(object.fixDef)
    object.setType('static')    
    object.setState(options)
    @objects.push(object) 
    return object     
   
  addBanana: (options) ->
    object = new EaselBoxBanana(options)  
    #@easelStage.addChild object.easelObj
    object.body = @box2dWorld.CreateBody(object.bodyDef)
    object.body.CreateFixture(object.fixDef)
    object.setType('dynamic')
    object.setState(options)
    @objects.push(object)
    return object
   
  @removeBanana: () ->
    @easelStage.removeChild(@easelStage.getNumChildren()-1)
   
  addMonkey: (options) ->
    object = new EaselBoxMonkey(options)
    #add to canvas
    @easelStage.addChild object.easelObj
    
    #create the actual Box2D bodies
    object.headbody = @box2dWorld.CreateBody(object.bodyDefHead)
    object.torsobody = @box2dWorld.CreateBody(object.bodyDefTorso)
    object.lowerbodybody = @box2dWorld.CreateBody(object.bodyDefLowerbody)
    #bind bodies to shapes
    object.headbody.CreateFixture(object.fixDefHead)
    object.torsobody.CreateFixture(object.fixDefTorso)
    object.lowerbodybody.CreateFixture(object.fixDefLowerbody)
    object.setType('static')
    object.setState(options)
    @objects.push(object)    
    #CREATE WELD JOINTS BETWEEN (HEAD,TORSO) AND (TORSO,LOWERBODY)
    #head->torso
    object.headtorsoweldJointDef.Initialize(object.headbody,object.torsobody,object.headbody.GetWorldCenter())
    #torso->lower body
    object.torsolowerbodyweldJointDef.Initialize(object.torsobody,object.lowerbodybody,object.lowerbodybody.GetWorldCenter())
    @box2dWorld.CreateJoint(object.headtorsoweldJointDef)
    @box2dWorld.CreateJoint(object.torsolowerbodyweldJointDef)  
    return object
    
  addBox: (options) ->
    object = new EaselBoxBox(options)  
    @easelStage.addChild object.easelObj
    object.setState(options)
    @objects.push(object)
    return object
    
  addArrow: (options) ->
    object=new EaselBoxArrow(options)
    #add to canvas
    @easelStage.addChild object.easelObj
    #create the actual Box2D bodies
    #object.arrowbody.CreateFixture(object.arrowbodyFixDef)
    #object.arrowhead.CreateFixture(object.arrowheadFixDef)
    #object.setType
    object.setState(options)
    @objects.push(object) 
    return object  
  
 
  addEntity: (options) -> 
    object = null
    if options.whoami
      object = new EaselBoxLandscapeRectangle(options)
    else if options.radiusPixels
      object = new EaselBoxCircle(options.radiusPixels, options)
    else
      object = new EaselBoxRectangle(options.widthPixels, options.heightPixels, options)

    @easelStage.addChild object.easelObj
    object.body = @box2dWorld.CreateBody(object.bodyDef)
    object.body.CreateFixture(object.fixDef)
    object.setType(options.type || 'dynamic') #make it dynamic only if it has not been defined as static
    object.setState(options)
    
    @objects.push(object)
    return object
   
  removeEntity: (object) ->
    @box2dWorld.DestroyBody(object.body)
    @easelStage.removeChild(object.easelObj)
     
  addImage: (imgSrc, options) ->
    obj = new Bitmap(imgSrc)
    for property, value of options
      obj[property] = value
    @easelStage.addChild obj

  tick: ->
    if Ticker.getMeasuredFPS() > minFPS
      @box2dWorld.Step (1 / Ticker.getMeasuredFPS()), 10, 10 
      @box2dWorld.ClearForces()
      for object in @objects
        object.update()
    
    # check to see if main object has a callback for each tick
    if typeof @callingObj.tick == 'function'
      @callingObj.tick()
 
    @easelStage.update()
    @box2dWorld.DrawDebugData()
  
  vector: (x, y) ->
    new Box2D.Common.Math.b2Vec2(x, y)  