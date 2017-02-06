
FlowRouter.route '/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'page_view'




if Meteor.isClient
    Template.page_view.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    
    
    Template.page_view.helpers
        item: ->
            Docs.findOne FlowRouter.getParam('doc_id')
    
        can_buy: ->
            @point_price < Meteor.user().points
    
    Template.page_view.events
        'click .edit': ->
            doc_id = FlowRouter.getParam('doc_id')
            FlowRouter.go "/edit/#{doc_id}"


        'click #add_to_cart': ->
            Meteor.call 'add_to_cart', @_id, ->
                FlowRouter.go '/cart'