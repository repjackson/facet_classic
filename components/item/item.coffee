if Meteor.isClient
    Template.item.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'secondary' else 'basic'
    
        when: -> moment(@timestamp).fromNow()

    Template.item.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
    
        'click .edit': -> FlowRouter.go("/edit/#{@_id}")

