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


Meteor.methods
    add: (tags=[])->
        id = Docs.insert
            tags: tags
        return id

    clone: (original_id)->
        original = Docs.findOne original_id
        id = Docs.insert
            tags: original.tags
        return id
