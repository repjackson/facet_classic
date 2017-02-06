FlowRouter.route '/cart', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'cart'






if Meteor.isClient
    Template.cart.onCreated -> 
        @autorun -> Meteor.subscribe('cart')

    
    
    Template.cart.helpers
        cart_items: ->
            me = Meteor.user()
            if me
                Docs.find
                    _id: $in: me.profile.cart

        
        item_count: ->
            me = Meteor.users.findOne Meteor.userId()
            if me
                Docs.find( _id: $in: me.profile.cart ).count()
            
        price_total: ->
            total = 0
            me = Meteor.users.findOne Meteor.userId()
            if me
                for item in Docs.find( _id: $in: me.profile.cart ).fetch()
                    total = total + item.point_price
                total


    Template.cart.events
        'click .remove_item': ->
            Meteor.users.update Meteor.userId(),
                $pull: 'profile.cart': @_id
        
        
        
if Meteor.isServer
    Meteor.publish 'cart', ->
        me = Meteor.users.findOne @userId
        
        Docs.find 
            _id: $in: me.profile.cart
    
    
    Meteor.methods
        add_to_cart: (doc_id)->
            Meteor.users.update Meteor.userId(),
                $addToSet: "profile.cart": doc_id