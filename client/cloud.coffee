@selected_tags = new ReactiveArray []

Template.cloud.onCreated ->
    @autorun -> Meteor.subscribe('tags', selected_tags.array())

Template.cloud.helpers
    all_tags: ->
        # doc_count = Docs.find().count()
        # if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()
        Tags.find()

    # tag_cloud_class: ->
    #     button_class = switch
    #         when @index <= 5 then 'big'
    #         when @index <= 10 then 'large'
    #         when @index <= 15 then ''
    #         when @index <= 20 then 'small'
    #     return button_class
    
    tag_cloud_class: ->
        button_class = switch
            when @index <= 10 then 'massive'
            when @index <= 20 then 'huge'
            when @index <= 30 then 'big'
            when @index <= 40 then 'large'
            when @index <= 50 then ''
        return button_class

    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Tags
                field: 'name'
                matchAll: true
                template: Template.tag_result
            }
            ]
    }
    

    selected_tags: -> selected_tags.array()


Template.cloud.events
    'click .select_tag': -> selected_tags.push @name
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()
    
    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_tags.pop()
                    
    'keyup #quick_add': (e,t)->
        e.preventDefault
        tag = $('#quick_add').val().toLowerCase()
        switch e.which
            when 13
                if tag.length > 0
                    split_tags = tag.match(/\S+/g)
                    $('#quick_add').val('')
                    Meteor.call 'add', split_tags
                    selected_tags.clear()
                    for tag in split_tags
                        selected_tags.push tag
            when 8
                if tag.length is 0
                    selected_tags.pop()

    'click #logout': -> AccountsTemplates.logout()
                    
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_tags.push doc.name
        $('#search').val ''

