Template.edit.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


Template.edit.helpers
    doc: ->  Docs.findOne FlowRouter.getParam('doc_id')

        
Template.edit.events
    'keydown #add_tag': (e,t)->
        if e.which is 13
            doc_id = FlowRouter.getParam('doc_id')
            tag = $('#add_tag').val().toLowerCase().trim()
            if tag.length > 0
                Docs.update doc_id,
                    $addToSet: tags: tag
                $('#add_tag').val('')
            else
                selected_tags.clear()
                selected_tags.push tag for tag in @tags
                FlowRouter.go "/"


    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: tags: tag
        $('#add_tag').val(tag)


    'blur #body': (e,t)->
        body = $('#body').val()
        
        doc_id = FlowRouter.getParam('doc_id')

        Docs.update doc_id,
            $set: 
                body: body


    'click #delete': ->
        if confirm 'delete?'
            Docs.remove FlowRouter.getParam('doc_id')
            FlowRouter.go '/'


    'click #save': (e,t)->
        selected_tags.clear()
        selected_tags.push tag for tag in @tags
        FlowRouter.go "/"


