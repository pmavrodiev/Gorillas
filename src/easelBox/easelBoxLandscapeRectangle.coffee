class window.EaselBoxLandscapeRectangle extends EaselBoxObject

    
  constructor: (options) ->
    #INIT THE EASEL SHAPE
    object = new Shape()    
    #object.graphics.beginStroke("white")
    #object.graphics.beginLinearGradientFill(["lightblue","lightgreen"], [0.05, 0.9], 40, 100, 0, 150)
    #object.graphics.beginLinearGradientStroke(["lightblue","lightgreen"], [0.05, 0.9], 40, 100, 0, 150)
    #object.graphics.beginBitmapFill(im,"repeat")
    #object.graphics.setStrokeStyle(0)
    #set origin
    #object.graphics.moveTo(options.bottom_left_corner.x,options.bottom_left_corner.y)    
    #bottom_left to top_left
    #object.graphics.lineTo(options.top_left_corner.x,options.top_left_corner.y)
    #top_left to top_right
    #object.graphics.lineTo(options.top_right_corner.x,options.top_right_corner.y)
    #top_right to bottom_right
    #object.graphics.lineTo(options.bottom_right_corner.x,options.bottom_right_corner.y)
  
    #INIT THE BOX2D PHYSICS ENTITY 
    hillVector = new Vector(4)
    x1 = options.bottom_left_corner.x / PIXELS_PER_METER; y1 =  options.bottom_left_corner.y / PIXELS_PER_METER;
    x2 = options.top_left_corner.x / PIXELS_PER_METER; y2 =  options.top_left_corner.y / PIXELS_PER_METER
    x3 = options.top_right_corner.x / PIXELS_PER_METER; y3 =  options.top_right_corner.y / PIXELS_PER_METER
    x4 = options.bottom_right_corner.x / PIXELS_PER_METER; y4 =  options.bottom_right_corner.y / PIXELS_PER_METER
    hillVector[0] = new Box2D.Common.Math.b2Vec2 x1,y1      #bottom-left
    hillVector[1] = new Box2D.Common.Math.b2Vec2 x2,y2      #top-left
    hillVector[2] = new Box2D.Common.Math.b2Vec2 x3,y3      #top-right
    hillVector[3] = new Box2D.Common.Math.b2Vec2 x4,y4      #bottom-right

    box2dShape = new Box2D.Collision.Shapes.b2PolygonShape.AsArray hillVector,4
    super(object, box2dShape, options)
    
 
   
      
