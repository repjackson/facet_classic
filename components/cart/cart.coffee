FlowRouter.route '/cart', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'cart'






if Meteor.isClient
    Template.cart.onCreated -> 
        @autorun -> Meteor.subscribe('cart')

    
    
    Template.cart.helpers
        cart_items: ->
            Docs.find()
        
        
        
        
if Meteor.isServer
    Meteor.publish 'cart', ->
        me = Meteor.users.findOne @userId
        
        Docs.find 
            _id: $in: me.profile.cart
    
    
    Meteor.methods
        add_to_cart: (doc_id)->
            Meteor.users.update Meteor.userId(),
                $addToSet: "profile.cart": doc_id