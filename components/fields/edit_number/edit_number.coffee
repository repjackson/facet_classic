if Meteor.isClient
    Template.edit_number.events
        'change #number': ->
            doc_id = FlowRouter.getParam('doc_id')
            location = $('#number').val()
            int = parseInt location
            
            Docs.update doc_id,
                $set: number: int


