Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()


Template.registerHelper 'is_dev', () -> Meteor.isDevelopment


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
