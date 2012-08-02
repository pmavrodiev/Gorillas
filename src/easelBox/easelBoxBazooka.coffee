class window.EaselBoxBazooka
  constructor: (options) ->  
    #INIT THE EASEL SHAPE
    @easelObj = new Bitmap(options.imgSrc)
    @easelObj.regX = options.regX
    @easelObj.regY = options.regY
    @easelObj.globalRegX = options.regX + options.xPixels
    @easelObj.globalRegY = options.regY + options.yPixels        
    @easelObj.angle=0 
    @prev_angle=0      
   
    
    
    @easelObj.onPress = (eventPress) =>
      @easelObj.angle = @prev_angle            
      eventPress.onMouseMove = (event) =>
        @easelObj.angle=@prev_angle+Math.PI/2 - 
                        Math.atan2(@easelObj.globalRegY-event.stageY,event.stageX-@easelObj.globalRegX)-
                        Math.atan2(eventPress.stageX-@easelObj.globalRegX,@easelObj.globalRegY-eventPress.stageY)
        @setState(
         angleRadians: @easelObj.angle,
         xPixels: @easelObj.x, 
         yPixels: @easelObj.y         
         )        
      eventPress.onMouseUp = (event) =>
         @prev_angle = @easelObj.angle
         theta =  Math.atan2(@easelObj.globalRegY-event.stageY,event.stageX-@easelObj.globalRegX)
         beta =  Math.atan2(eventPress.stageX-@easelObj.globalRegX,@easelObj.globalRegY-eventPress.stageY)
         alert(@easelObj.angle*180/Math.PI+","+
               theta*180/Math.PI+","+
               beta*180/Math.PI+",["+
               @easelObj.globalRegX+":"+@easelObj.globalRegY+"],["+
               eventPress.stageX+":"+eventPress.stageY+"],["+
               event.stageX+":"+event.stageY
               )
         
    # init the Box2d physics entity
    regPoint = new Box2D.Common.Math.b2Vec2(-10,-10)
    box2dShape = new Box2D.Collision.Shapes.b2PolygonShape.AsBox((options.width/PIXELS_PER_METER)/2,
                                                                 (options.height/PIXELS_PER_METER)/2)
                                                                 
    density = (options and options.density) or 1
    friction = (options and options.friction) or 0.5
    restitution = (options and options.restitution) or 0.2
    @fixDef = new Box2D.Dynamics.b2FixtureDef
    @fixDef.density = density
    @fixDef.friction = friction
    @fixDef.restitution = restitution
    @fixDef.shape = box2dShape
    @bodyDef= new Box2D.Dynamics.b2BodyDef
    @body = null
  
  #update canvas position based on the physical position of the torso!
  update: () ->
     @easelObj.x = @body.GetPosition().x * PIXELS_PER_METER
     @easelObj.y = (@body.GetPosition().y+2.3) * PIXELS_PER_METER
     @easelObj.rotation = @body.GetAngle() * (180 / Math.PI)
    
  setType: (type) ->
    @body.SetType(getType(type))
   
  setState: (options) ->
    # let's do all the conversions here for you, so you can specify properties in either 
    # pixels or meters, and degrees or radians

    if options and options.xPixels
      xPixels = options.xPixels
      xMeters = xPixels / PIXELS_PER_METER
    else if options and options.Xmeters
      xMeters = options.Xmeters
      xPixels = xMeters * PIXELS_PER_METER
    else
      xMeters = 0
      xPixels = 0
      
    if options and options.yPixels
      yPixels = options.yPixels
      yMeters = yPixels / PIXELS_PER_METER
    else if options and options.Xmeters
      yMeters = options.Ymeters
      yPixels = YMeters * PIXELS_PER_METER
    else
      yMeters = 0
      yPixels = 0
    
    if options and options.xVelPixels
      xVelPixels = options.xVelPixels
      xVelMeters = xVelPixels / PIXELS_PER_METER
    else if options and options.xVelMeters
      xVelMeters = options.xVelMeters
      xVelPixels = xVelMeters * PIXELS_PER_METER
    else
      xVelMeters = 0
      xVelPixels = 0
          
    if options and options.yVelPixels
      yVelPixels = options.yVelPixels
      yVelMeters = yVelPixels / PIXELS_PER_METER
    else if options and options.yVelMeters
      yVelMeters = options.yVelMeters
      yVelPixels = yVelMeters * PIXELS_PER_METER
    else
      yVelMeters = 0
      yVelPixels = 0
      
    if options and options.angleDegrees
      angleDegrees = options.angleDegrees
      angleRadians = Math.PI * angleDegrees / 180 
    else if options and options.angleRadians
      angleRadians = options.angleRadians
      angleDegrees = 180 * angleRadians / Math.PI
    else
      angleRadians = 0
      angleDegrees = 0
      
    if options and options.angularVelRadians
      angularVelRadians = options.angularVelRadians
      angularVelDegrees = 180 * angularVelRadians / Math.PI
    else if options and options.angularVelDegrees
      angularVelDegrees = options.angularVelDegrees
      angularVelRadians = Math.PI * angularVelDegrees / 180 
    else
      angularVelDegrees = 0
      angularVelRadians = 0     
    
    # FOR EASEL
    @easelObj.x = xPixels
    @easelObj.y = yPixels
    @easelObj.rotation = angleDegrees

    # FOR BOX2D
    #torso
    @body.GetPosition().x = xMeters
    @body.GetPosition().y = yMeters - 2.3  #-2.3 to align the easel and box2d objects vertically
    @body.SetAngle(angleRadians)
    @body.SetAngularVelocity(angularVelRadians)
    @body.SetLinearVelocity(new Box2D.Common.Math.b2Vec2(xVelMeters, yVelMeters))
    #massdata = new Box2D.Collision.Shapes.b2MassData()
    #@body.GetMassData(massdata)
    #massdata.center.Set(0,3) #Set(x,y)    
    #@body.SetMassData massdata
    
    
  getType= (type) ->
    if 'dynamic' == type
      Box2D.Dynamics.b2Body.b2_dynamicBody
    else if 'static' == type
      Box2D.Dynamics.b2Body.b2_staticBody
    else if 'kinematic' == type
      Box2D.Dynamics.b2Body.b2_kinematicBody