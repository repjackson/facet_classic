Template.page_view.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')



Template.page_view.helpers
    doc: ->
        Docs.findOne FlowRouter.getParam('doc_id')


Template.page_view.events
    'click .edit': ->
        doc_id = FlowRouter.getParam('doc_id')
        FlowRouter.go "/edit/#{doc_id}"
