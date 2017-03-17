FlowRouter.route '/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit'


if Meteor.isClient
    
    Template.edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    
    Template.edit.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')
        
    
            
            
    Template.edit.events
        'click #save': ->
            selected_tags.clear()
            selected_tags.push tag for tag in @tags
            FlowRouter.go "/"
