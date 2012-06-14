class window.EaselBoxMonkey

  constructor: (options) ->
    #INIT THE EASEL SHAPE
    @easelObj = new Bitmap(options.imgSrc)
    @easelObj.regX = options.regX
    @easelObj.regY = options.regY
    @easelObj.scaleX = options.scaleX
    @easelObj.scaleY = options.scaleY
    
    #INIT THE BOX2D COMPLEX SHAPE   
    @size_head_meters = options.size_head / PIXELS_PER_METER
    @size_torso_meters = options.size_torso / PIXELS_PER_METER
    @size_lowerbody_meters = options.size_lowerbody / PIXELS_PER_METER
    #head
    @monkeyhead            = new Box2D.Collision.Shapes.b2PolygonShape.AsBox(@size_head_meters,@size_head_meters)
    #@monkeyhead.m_centroid = new Box2D.Common.Math.b2Vec2(options.xPixels/PIXELS_PER_METER,options.yPixels/PIXELS_PER_METER-size_torso_meters-size_head_meters) 
    #torso   
    @monkeytorso            = new Box2D.Collision.Shapes.b2PolygonShape.AsBox(@size_torso_meters,@size_torso_meters)
    #@monkeytorso.m_centroid = new Box2D.Common.Math.b2Vec2(options.xPixels/PIXELS_PER_METER,options.yPixels/PIXELS_PER_METER) 
    #lower body   
    @monkeylowerbody            = new Box2D.Collision.Shapes.b2PolygonShape.AsBox(@size_lowerbody_meters,@size_lowerbody_meters)
    #@monkeylowerbody.m_centroid = new Box2D.Common.Math.b2Vec2(options.xPixels/PIXELS_PER_METER,options.yPixels/PIXELS_PER_METER+size_torso_meters+size_lowerbody_meters)
  
    #CREATE FIXTURES AND (EMPTY) BODY DEFINITIONS FOR THE THREE BODY PARTS OF THE MONKEY
    #head
    density = (options and options.density) or 1
    friction = (options and options.friction) or 0.5
    restitution = (options and options.restitution) or 0.2
    @fixDefHead = new Box2D.Dynamics.b2FixtureDef
    @fixDefHead.density = density
    @fixDefHead.friction = friction
    @fixDefHead.restitution = restitution
    @fixDefHead.shape = @monkeyhead
    @bodyDefHead = new Box2D.Dynamics.b2BodyDef
    @headbody = null
    #torso
    @fixDefTorso = new Box2D.Dynamics.b2FixtureDef
    @fixDefTorso.density = density
    @fixDefTorso.friction = friction
    @fixDefTorso.restitution = restitution
    @fixDefTorso.shape = @monkeytorso
    @bodyDefTorso = new Box2D.Dynamics.b2BodyDef
    @torsobody = null

    #lower body
    @fixDefLowerbody = new Box2D.Dynamics.b2FixtureDef
    @fixDefLowerbody.density = density
    @fixDefLowerbody.friction = friction
    @fixDefLowerbody.restitution = restitution
    @fixDefLowerbody.shape = @monkeylowerbody
    @bodyDefLowerbody = new Box2D.Dynamics.b2BodyDef
    @lowerbodybody = null
    #CREATE WELD JOINTS BETWEEN (HEAD,TORSO) AND (TORSO,LOWERBODY)
    #head->torso
    @headtorsoweldJointDef = new Box2D.Dynamics.Joints.b2WeldJointDef()
    #torso->lower body
    @torsolowerbodyweldJointDef = new Box2D.Dynamics.Joints.b2WeldJointDef()
    
    
            
    @easelObj.onPress = (eventPress) =>
      #@setState(xPixels: eventPress.stageX, yPixels: eventPress.stageY)
     
      eventPress.onMouseMove = (event) =>
        @setState(xPixels: event.stageX, yPixels: event.stageY)  
         

  # update canvas position based on the physical position of the torso!
  update: ->
    @easelObj.x = @torsobody.GetPosition().x * PIXELS_PER_METER
    @easelObj.y = @torsobody.GetPosition().y * PIXELS_PER_METER
    @easelObj.rotation = @torsobody.GetAngle() * (180 / Math.PI)
    
    
  ApplyForce: (worldgravity) ->
    #apply anti gravity to each of the three components
    #head
    @headbody.ApplyForce(@headbody.GetMass()* -worldgravity,@headbody.GetWorldCenter())
    #torso
    @torsobody.ApplyForce(@torsobody.GetMass()* -worldgravity,@torsobody.GetWorldCenter())
    #lower body
    @lowerbodybody.ApplyForce(@lowerbodybody.GetMass()* -worldgravity,@lowerbodybody.GetWorldCenter())
    
  setType: (type) ->
    @headbody.SetType(getType(type))
    @torsobody.SetType(getType(type))
    @lowerbodybody.SetType(getType(type))
  
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
    #head
    @headbody.GetPosition().x = xMeters
    @headbody.GetPosition().y = yMeters-@size_torso_meters-@size_head_meters-0.1
    @headbody.SetAngle(angleRadians)
    @headbody.SetAngularVelocity(angularVelRadians)
    @headbody.SetLinearVelocity(new Box2D.Common.Math.b2Vec2(xVelMeters, yVelMeters))
    #torso
    @torsobody.GetPosition().x = xMeters
    @torsobody.GetPosition().y = yMeters
    @torsobody.SetAngle(angleRadians)
    @torsobody.SetAngularVelocity(angularVelRadians)
    @torsobody.SetLinearVelocity(new Box2D.Common.Math.b2Vec2(xVelMeters, yVelMeters))
    #lower body 
    @lowerbodybody.GetPosition().x = xMeters
    @lowerbodybody.GetPosition().y = yMeters+@size_torso_meters+@size_lowerbody_meters+0.1
    @lowerbodybody.SetAngle(angleRadians)
    @lowerbodybody.SetAngularVelocity(angularVelRadians)
    @lowerbodybody.SetLinearVelocity(new Box2D.Common.Math.b2Vec2(xVelMeters, yVelMeters))
        
  getType = (type) ->
    if 'dynamic' == type
      Box2D.Dynamics.b2Body.b2_dynamicBody
    else if 'static' == type
      Box2D.Dynamics.b2Body.b2_staticBody
    else if 'kinematic' == type
      Box2D.Dynamics.b2Body.b2_kinematicBody
    

