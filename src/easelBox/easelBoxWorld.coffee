PIXELS_PER_METER = 30

class window.EaselBoxWorld
  minFPS = 10 # weird stuff happens when we step through the physics when the frame rate is lower than this
  landscape_voffset = 0 #dummy init
  ###
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
  ###  
  constructor: (@callingObj, frameRate, canvas, debugCanvas, gravityX, gravityY, @pixelsPerMeter) -> 
    PIXELS_PER_METER = @pixelsPerMeter
    @landscape_voffset = canvas.height-150
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
    
  #generate a random landscape via the midpoint displacement method
  #height_offset - the base line for the landscape
  #min/max_width - the left and right boundaries of the canvas
  #iterations - # of iterations for the algorithm
  #r - roughness of the generated landscape
  generate_vpoints = (height_offset,min_width,max_width,iterations,r) ->
    class bound
      #min_/max_ idx - the left and right indeces of the landscape range
      #iteration - which iteration of the algorithm this range belongs to
      constructor: (min_idx,max_idx,iteration) ->
        @min_idx = min_idx; @max_idx = max_idx; @iteration = iteration
  
    #scale = (growth_rate,iterations,current_iteration) ->
    #  M = iterations / 2; Q = 0.5; v = 0.5
    #  return 1 - 1 / Math.pow(1+Q*Math.exp(-growth_rate*(current_iteration-M)),1/v)
      
    min = -50; max = 50 #random number range
    ticks = Math.pow(2,iterations)     
    bin_size = (max_width - min_width) / ticks
    vpoints_vector = new Array(ticks+1)
    vpoints_vector[0] = new Array(2); vpoints_vector[ticks] = new Array(2)
    vpoints_vector[0][0] = min_width; vpoints_vector[0][1] = height_offset
    vpoints_vector[ticks][0] = max_width; vpoints_vector[ticks][1] = height_offset
    queue = new Array(); 
    queue.push(new bound(0,ticks,1)) #indexed from 0 and first iteration!
    while queue.length > 0      
      #always get the first element
      firstElement = queue.shift()
      left_idx = firstElement.min_idx; right_idx = firstElement.max_idx; iter = firstElement.iteration
      if right_idx - left_idx > 1 #not adjacent indeces
        midpoint_x = (vpoints_vector[right_idx][0]+vpoints_vector[left_idx][0]) / 2
        midpoint_y = (vpoints_vector[right_idx][1]+vpoints_vector[left_idx][1]) / 2
        if iter > 1
          #min = min*scale(r,iterations,iter); #max = max*scale(r,iterations,iter)
          min = min*Math.pow(2,-r); max = max*Math.pow(2,-r)
        if iter == 1
          midpoint_y = midpoint_y + Math.random() * (-100 - 5*min) + 5*min; #disturb the y coordinate
        else  
          midpoint_y = midpoint_y + Math.random() * (max - min) + min; #disturb the y coordinate
          
        midpoint_index = (left_idx+right_idx)/2 
        vpoints_vector[midpoint_index] = new Array(2)
        vpoints_vector[midpoint_index][0]= midpoint_x
        vpoints_vector[midpoint_index][1]= midpoint_y       
        #breadth first search style
        queue.push(new bound(left_idx,(right_idx+left_idx)/2,iter+1)); 
        queue.push(new bound((right_idx+left_idx)/2,right_idx,iter+1))    
    return vpoints_vector
    
    
  addLandscape: (dimensions) ->
    
    if dimensions.height and dimensions.width
      landscape_vpoints = generate_vpoints(@landscape_voffset,0,dimensions.width,20,0.05) #the vertical points of the landscape
      landscape = new Shape()      
      landscape.graphics.beginStroke("grey")
      landscape.graphics.setStrokeStyle(2)
      landscape.graphics.moveTo(0,@landscape_voffset)
      #for i in [1..(landscape_vpoints.length-1)] # we don't need the first point, hence 1 as start index
      #  landscape.graphics.lineTo(landscape_vpoints[i][0],landscape_vpoints[i][1])  
      
      @easelStage.addChild landscape
    
    
  addEntity: (options) -> 
    object = null
    if options.radiusPixels
      object = new EaselBoxCircle(options.radiusPixels, options)
    else
      object = new EaselBoxRectangle(options.widthPixels, options.heightPixels, options)

    @easelStage.addChild object.easelObj
    object.body = @box2dWorld.CreateBody(object.bodyDef)
    object.body.CreateFixture(object.fixDef)
    object.setType(options.type || 'dynamic')
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