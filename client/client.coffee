Template.docs.onCreated -> 
    @autorun -> Meteor.subscribe('docs', selected_tags.array())

Template.docs.helpers
    docs: -> 
        Docs.find { }, 
            sort:
                tag_count: 1
            limit: 1

    one_doc: ->
        Docs.find().count() is 1


Template.doc.helpers
    is_author: -> Meteor.userId() and @author_id is Meteor.userId()

    tag_class: -> if @valueOf() in selected_tags.array() then 'white' else 'grey compact'

Template.doc.events
    'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())

    'click .edit': -> FlowRouter.go("/edit/#{@_id}")

    'click .delete': ->
        if confirm 'delete?'
            Docs.remove @_id
            selected_tags.clear()
