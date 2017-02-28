@Docs = new Meteor.Collection 'docs'

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    doc.group_id = Meteor.user().profile.current_group_id
    doc.group_name = Meteor.user().profile.current_group_name
    return

Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags?.length
), fetchPrevious: true


Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()


Meteor.methods
    add: ()->
        id = Docs.insert {}
        return id


if Meteor.isClient
    Template.docs.onCreated -> 
        @autorun -> Meteor.subscribe('docs', selected_tags.array(), FlowRouter.getParam('group_id') )

    Template.docs.helpers
        docs: -> 
            Docs.find { }, 
                sort:
                    tag_count: 1
                limit: 1
    
    
    Template.docs.events

    Template.item.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'active' else 'compact'
    
        when: -> moment(@timestamp).fromNow()

    Template.item.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
    
        'click .edit': -> FlowRouter.go("/edit/#{@_id}")



if Meteor.isServer
    Docs.allow
        insert: (userId, doc) -> doc.author_id is userId
        update: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
    
    
    
    
    Meteor.publish 'docs', (selected_tags, group_id)->
        
        self = @
        match = {}
        # if selected_tags.length > 0 then match.tags = $all: selected_tags
        match.tags = $all: selected_tags
    
        match.group_id = group_id
        
        Docs.find match,
            limit: 5
            
    
    Meteor.publish 'doc', (id)->
        Docs.find id
    
    
    
