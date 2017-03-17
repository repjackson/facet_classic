FlowRouter.route '/', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'docs'
