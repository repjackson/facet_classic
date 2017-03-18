Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

Template.docs.onCreated -> 
    @autorun -> Meteor.subscribe('docs', selected_tags.array())

Template.docs.helpers
    docs: -> 
        Docs.find { }, 
            sort:
                tag_count: 1
            limit: 5


Template.docs.events

Template.doc.helpers
    is_author: -> Meteor.userId() and @author_id is Meteor.userId()

    tag_class: -> if @valueOf() in selected_tags.array() then 'active' else 'compact'

Template.doc.events
    'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())

    'click .edit': -> FlowRouter.go("/edit/#{@_id}")

    'click .clone': ->
        Meteor.call 'clone', @_id, (err,id)->
            FlowRouter.go "/edit/#{id}"

    'click .delete': ->
        if confirm 'delete?'
            Docs.remove @_id
            selected_tags.clear()
