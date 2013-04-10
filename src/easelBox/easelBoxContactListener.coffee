class window.EaselBoxContactListener extends Box2D.Dynamics.b2ContactListener
  class MyContact
    constructor: (fixtureA, fixtureB) ->
      @fixtureA = fixtureA
      @fixtureB = fixtureB
         
         
  constructor: () ->
    @contacts = []
    
  BeginContact: (contact) ->
    mycontact = new MyContact(contact.GetFixtureA(),contact.GetFixtureB())
    @contacts.push(mycontact)

  EndContact: (contact) ->
    endcontact = new MyContact(contact.GetFixtureA(),contact.GetFixtureB())
    index = 0    
    for i in @contacts      
      if endcontact.fixtureA == i.fixtureA and endcontact.fixtureB == i.fixtureB        
        break
      index++
    
    if (index>=0)
      @contacts.splice(index,1)
    
