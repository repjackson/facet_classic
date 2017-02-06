if Meteor.isClient
    Template.nav.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'me'
    

    
    Template.nav.events
        'click #logout': -> AccountsTemplates.logout()
        
        
        'click #add': ->
            Meteor.call 'add', (err,id)->
                FlowRouter.go "/edit/#{id}"

if Meteor.isServer
    Meteor.publish 'me', ->
        Meteor.users.find @userId,
            fields:
                profile: 1
                points: 1