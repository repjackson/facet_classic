FlowRouter.route '/test', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'test'


Template.test.onCreated -> 
    @autorun -> Meteor.subscribe('docs', ['course', 'sol'])


Template.test.helpers
    fo: (tag) ->
        # split_tags = tags.match(/\S+/g)
        doc = Docs.findOne(tags: $in: [tag])
        # console.log tag
        if doc
            return doc.body