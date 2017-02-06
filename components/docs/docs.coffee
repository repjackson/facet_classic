@Docs = new Meteor.Collection 'docs'

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    doc.type = 'service'
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
        @autorun -> Meteor.subscribe('docs', selected_tags.array())

    Template.docs.helpers
        docs: -> 
            Docs.find { }, 
                sort:
                    tag_count: 1
                limit: 10
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'secondary' else 'basic'


    
    Template.docs.events



if Meteor.isServer
    Docs.allow
        insert: (userId, doc) -> doc.author_id is userId
        update: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
    
    
    
    
    Meteor.publish 'docs', (selected_tags)->
    
        self = @
        match = {}
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        match.type = 'service'
    
        Docs.find match,
            limit: 5
            
    
    Meteor.publish 'doc', (id)->
        Docs.find id
    
    
    
