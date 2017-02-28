@Groups = new Meteor.Collection 'groups'


Groups.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    doc.members = []
    
    return

Groups.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags?.length
), fetchPrevious: true


Groups.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()


FlowRouter.route '/groups', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'groups'





if Meteor.isClient
    Template.group_items.onCreated ->
        @autorun -> Meteor.subscribe('groups', selected_group_tags.array())
    
    Template.group_cloud.events
        'click #add_group': ->
            id = Groups.insert {}
            FlowRouter.go "/group/edit/#{id}"
    
    Template.group_items.helpers
        groups: -> 
            Groups.find()
            

    Template.group_item.helpers
        group_tag_class: -> if @valueOf() in selected_group_tags.array() then 'primary' else ''
    
    
if Meteor.isServer
    
    
    Groups.allow
        insert: (userId, doc) -> doc.author_id is userId
        update: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
    

    
    Meteor.publish 'groups', (selected_group_tags)->
        match = {}
        if selected_group_tags.length > 0 then match.tags = $all: selected_group_tags

        Groups.find match
