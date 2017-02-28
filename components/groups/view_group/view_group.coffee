
FlowRouter.route '/group/view/:group_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_group'




if Meteor.isClient
    Template.view_group.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'group', FlowRouter.getParam('group_id')
            self.subscribe 'group_member_list', FlowRouter.getParam('group_id')
    
    
    
    Template.view_group.helpers
        group: ->
            Groups.findOne FlowRouter.getParam('group_id')
    
        is_member: ->
            Meteor.userId() in @members
            
        member_list: ->
            list = []
            for member_id in @members
                person = Meteor.users.findOne member_id
                list.push person
            return list
                
        is_inside_group: ->
            @_id is Meteor.user().profile.current_group_id
            
    
    Template.view_group.events
        'click .edit': ->
            group_id = FlowRouter.getParam('group_id')
            FlowRouter.go "/group/edit/#{group_id}"

        'click #add': ->
            Meteor.call 'add', (err,id)->
                FlowRouter.go "/edit/#{id}"


        'click #join_group': ->
            Groups.update FlowRouter.getParam('group_id'),
                $addToSet: members: Meteor.userId()
            Meteor.users.update Meteor.userId(),
                $addToSet: "profile.groups": FlowRouter.getParam('group_id')
                
        
        'click #leave_group': ->
            Groups.update FlowRouter.getParam('group_id'),
                $pull: members: Meteor.userId()
            Meteor.users.update Meteor.userId(),
                $pull: "profile.groups": FlowRouter.getParam('group_id')
            
        'click #go_inside_group': ->
            Meteor.call 'go_inside_group', @_id

        'click #go_outside_group': ->
            Meteor.call 'go_outside_group'



if Meteor.isServer
    Meteor.publish 'group', (id)->
        Groups.find id
    
    Meteor.publish 'group_member_list', (id)->
        Meteor.users.find 
            "profile.groups": $in: [id]
    
    Meteor.methods
        go_inside_group: (id)->
            group = Groups.findOne id
            Meteor.users.update Meteor.userId(),
                $set: 
                    "profile.current_group_id": id
                    "profile.current_group_name": group.name
        
        go_outside_group: ->
            Meteor.users.update Meteor.userId(),
                $unset: 
                    "profile.current_group_id": ""
                    "profile.current_group_name": ""
            