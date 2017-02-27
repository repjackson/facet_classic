FlowRouter.route '/group/edit/:group_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_group'




if Meteor.isClient
    Template.edit_group.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'group', FlowRouter.getParam('group_id')
    
    
    Template.edit_group.helpers
        group: ->
            Groups.findOne FlowRouter.getParam('group_id')
        
            
    Template.edit_group.events
        'click #save': ->
            FlowRouter.go "/group/view/#{@_id}"


        'keydown #add_tag': (e,t)->
            if e.which is 13
                group_id = FlowRouter.getParam('group_id')
                tag = $('#add_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Groups.update group_id,
                        $addToSet: tags: tag
                    $('#add_tag').val('')
    
        'click .doc_tag': (e,t)->
            organization = Groups.findOne FlowRouter.getParam('group_id')
            tag = @valueOf()
            Groups.update FlowRouter.getParam('group_id'),
                $pull: tags: tag
            $('#add_tag').val(tag)

        'blur #name': ->
            name = $('#name').val()
            Groups.update FlowRouter.getParam('group_id'),
                $set: name: name
        
        'blur #description': ->
            description = $('#description').val()
            Groups.update FlowRouter.getParam('group_id'),
                $set: description: description
        
        
        'blur #group_tag': ->
            group_tag = $('#group_tag').val()
            Groups.update FlowRouter.getParam('group_id'),
                $set: group_tag: group_tag
                
        
