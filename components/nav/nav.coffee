if Meteor.isClient
    Template.nav.events
        'click #logout': -> AccountsTemplates.logout()
        
        
        'click #add': ->
            Meteor.call 'add', (err,id)->
                FlowRouter.go "/edit/#{id}"
