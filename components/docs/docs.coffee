@Docs = new Meteor.Collection 'docs'

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return

Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags?.length
), fetchPrevious: true


Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()


Meteor.methods
    add: (group_id)->
        id = Docs.insert {}
        return id

    clone: (original_id)->
        original = Docs.findOne original_id
        id = Docs.insert
            tags: original.tags
        return id


if Meteor.isClient
    Template.docs.onCreated -> 
        @autorun -> Meteor.subscribe('docs', selected_tags.array())

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

        'click .clone': ->
            Meteor.call 'clone', @_id, (err,id)->
                FlowRouter.go "/edit/#{id}"

        'click .delete': ->
            if confirm 'delete?'
                Docs.remove @_id





if Meteor.isServer
    Docs.allow
        insert: (userId, doc) -> doc.author_id is userId
        update: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
    
    
    
    
    Meteor.publish 'docs', (selected_tags, group_id)->
        
        self = @
        match = {}
        match.tags = $all: selected_tags
    
        Docs.find match,
            limit: 5
            
    
    Meteor.publish 'doc', (id)->
        Docs.find id
    
    
    
