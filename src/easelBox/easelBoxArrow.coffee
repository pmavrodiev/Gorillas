class window.EaselBoxArrow   
  
  constructor: (options) ->
    #INIT THE EASEL SHAPE
    @x1=options.shape_coordinates[0]; @y1=options.shape_coordinates[1]   #A
    @x2=options.shape_coordinates[2]; @y2=options.shape_coordinates[3]   #B
    @x3=options.shape_coordinates[4]; @y3=options.shape_coordinates[5]   #C
    @x4=options.shape_coordinates[6]; @y4=options.shape_coordinates[7]   #D
    @x5=options.shape_coordinates[8]; @y5=options.shape_coordinates[9]   #E
    @x6=options.shape_coordinates[10]; @y6=options.shape_coordinates[11] #F
    @rotation = options.rotation | 0
    if options.imgSrc
      @easelObj = new Bitmap(options.imgSrc)
    else
      @easelObj = new Shape()
      #@easelObj.REGX = options.xPixels
      #@easelObj.REGY = options.yPixels
      @easelObj.REGX = 0
      @easelObj.REGY = 0

      @drawme()    
 
    #@easelObj.scaleX = options.scaleX
    #@easelObj.scaleY = options.scaleY    
            
    @easelObj.onPress = (eventPress) =>
      #alert(eventPress.stageX+" : "+eventPress.stageY)
      @rotateme(30)
      #@setState(xPixels: eventPress.stageX, yPixels: eventPress.stageY)
      #@easelObj.pressedX = eventPress.stageX
      #@easelObj.pressedY = eventPress.stageY
      
      eventPress.onMouseMove = (event) =>
       # deltaX = event.stageX - @easelObj.pressedX
       # deltaY = event.stageY - @easelObj.pressedY
       # @setState(xPixels: @easelObj.x+deltaX, yPixels: @easelObj.y+deltaY)
       # @easelObj.pressedX = event.stageX
       # @easelObj.pressedY = event.stageY
      eventPress.onMouseUp = (event) =>
         
  drawme: (xPixels,yPixels)  ->
      @easelObj.regX = @easelObj.REGX
      @easelObj.regY = @easelObj.REGY
       
      console.log (@x1 + ":" + @y1 + ":" +@x2 + ":" + @y2 + ":"+@x3 + ":" + @y3 + ":"+@x4 + ":" + @y4 + ":"+@x5 + ":" + @y5 + ":"+@x6 + ":" + @y6)
      @easelObj.graphics.clear()
      @easelObj.graphics.beginFill("pink")
      #@easelObj.graphics.setStrokeStyle(1)
      @easelObj.graphics.moveTo(@x1,@y1)
      @easelObj.graphics.lineTo(@x2,@y2)
      @easelObj.graphics.lineTo(@x3,@y3)
      @easelObj.graphics.lineTo(@x4,@y4)
      @easelObj.graphics.lineTo(@x5,@y5)
      @easelObj.graphics.lineTo(@x6,@y6) 
      #close the shape
      @easelObj.graphics.lineTo(@x3,@y3)
      @easelObj.graphics.lineTo(@x4,@y4)
      @easelObj.graphics.lineTo(@x1,@y1)
      @easelObj.setTransform(@rotation)

  rotateme: (angleDegrees) ->
      #rotate each point individually
      computePointRotation = (x,y,x1,y1,angleDegrees) ->
        class point
          constructor: ->
            @x = 0; @y = 0
    
        A = Math.pow(x-x1,2)+Math.pow(y1-y,2)
        B = 4*Math.pow(Math.sin((angleDegrees/2)*Math.PI/180),2)*A
        M = -(B + y1*y1 - y*y - A - Math.pow(x-x1,2))/2
        Z = 2*y1*Math.pow(x-x1,2) + 2*M*(y-y1) 
        N = A*Math.pow(x-x1,2) - M*M
        P = N - y1*y1*Math.pow(x-x1,2)
        point = new Point()
        point.y = (Z - Math.sqrt(Math.pow(Z,2)+4*A*P)) / (2*A)  
        point.x = x1 + Math.sqrt(A-Math.pow(y1-point.y,2))
        return point     
      x2rotated = computePointRotation(@x2,@y2,@x1,@y1,angleDegrees) 
      x3rotated = computePointRotation(@x3,@y3,@x1,@y1,angleDegrees)
      x4rotated = computePointRotation(@x4,@y4,@x1,@y1,angleDegrees)
      x5rotated = computePointRotation(@x5,@y5,@x1,@y1,angleDegrees)
      x6rotated = computePointRotation(@x6,@y6,@x1,@y1,angleDegrees)
      @x2 = x2rotated.x; @y2 = x2rotated.y
      @x3 = x3rotated.x; @y3 = x3rotated.y
      @x4 = x4rotated.x; @y4 = x4rotated.y
      @x5 = x5rotated.x; @y5 = x5rotated.y
      @x6 = x6rotated.x; @y6 = x6rotated.y
      console.log (@x1 + ":" + @y1 + ":" +@x2 + ":" + @y2 + ":"+@x3 + ":" + @y3 + ":"+@x4 + ":" + @y4 + ":"+@x5 + ":" + @y5 + ":"+@x6 + ":" + @y6)
      @drawme()
     
  # update canvas position based on the physical position of the torso!
  update: ->
    #@easelObj.x = @torsobody.GetPosition().x * PIXELS_PER_METER
    #@easelObj.y = @torsobody.GetPosition().y * PIXELS_PER_METER
    #@easelObj.rotation = @torsobody.GetAngle() * (180 / Math.PI)
    @easelObj.x =  @easelObj.x
    @easelObj.y = @easelObj.y
    @easelObj.rotation = @easelObj.rotation

    
  setType: (type) ->
    #@headbody.SetType(getType(type))
    #@torsobody.SetType(getType(type))
    #@lowerbodybody.SetType(getType(type))
  
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
   
        
  getType = (type) ->
    #if 'dynamic' == type
    #  Box2D.Dynamics.b2Body.b2_dynamicBody
    #else if 'static' == type
    #  Box2D.Dynamics.b2Body.b2_staticBody
    #else if 'kinematic' == type
    #  Box2D.Dynamics.b2Body.b2_kinematicBody
    