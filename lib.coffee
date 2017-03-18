FlowRouter.route '/', action: (params) ->
    BlazeLayout.render 'layout',
        cloud: 'cloud'
        main: 'docs'


FlowRouter.route '/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit'


FlowRouter.route '/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'page_view'

